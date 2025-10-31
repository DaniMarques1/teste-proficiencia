from django.shortcuts import render
from django.http import JsonResponse, HttpResponseForbidden
from django.forms.models import model_to_dict  
from questoes.models import Professores, Questoes, Respostas, NiveisDificuldade
from contas.models import Usuarios
from django.http import JsonResponse, HttpResponseBadRequest
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from contas.forms import UsuarioForm
from django.views.decorators.csrf import ensure_csrf_cookie
import json
from django.core.mail import send_mail
import random
from django.conf import settings
import time

def get_teacher(request, teacher_id):
    teacher_index = teacher_id - 1
    
    try:
        professor_obj = professores_queryset[teacher_index]        
        teacher_dict = model_to_dict(professor_obj)
        return JsonResponse(teacher_dict)

    except IndexError:
        return JsonResponse({'error': f'Teacher number {teacher_id} not found.'}, status=404)

def get_teachers(request): 
    # 1. order_by('?') ordena os resultados aleatoriamente no banco de dados.
    # 2. [:2] pega apenas os 2 primeiros resultados dessa ordenação aleatória.
    professores = Professores.objects.order_by('?')[:2]
    
    # Serializa os dados, excluindo 'telefone' e 'email'
    data = [model_to_dict(p, exclude=['telefone', 'email']) for p in professores]
    
    return JsonResponse(data, safe=False)

def get_question(request, question_id):
    # Obtemos todos os níveis de dificuldade com suas respectivas quantidades máximas
    niveis = NiveisDificuldade.objects.all()
    
    # Montamos uma lista de IDs de questões, respeitando o 'maximo_questoes' de cada nível
    questoes_filtradas = []
    for nivel in niveis:
        questoes_nivel = (
            Questoes.objects.filter(ativo=True, nivel_dificuldade=nivel.id)
            .order_by('id')[:nivel.maximo_questoes]
        )
        questoes_filtradas.extend(list(questoes_nivel))
    
    # Agora temos apenas as questões ativas limitadas conforme cada nível
    questoes_queryset = questoes_filtradas
    
    question_index = question_id - 1

    try:
        questao_obj = questoes_queryset[question_index]

        # Excluímos o campo 'explicacao' do retorno
        question_data = model_to_dict(questao_obj, exclude=['explicacao'])

        respostas_queryset = questao_obj.respostas_set.all()
        respostas_data = [
            {
                'id': r.id,
                'resposta': r.resposta,
                'questao': r.questao.id
            }
            for r in respostas_queryset
        ]

        question_data['respostas'] = respostas_data

        return JsonResponse(question_data)

    except IndexError:
        return JsonResponse(
            {'error': f'Question number {question_id} not found among active questions.'},
            status=404
        )
    
@require_http_methods(["POST"])
@csrf_exempt
def check_answer(request):
    try:
        data = json.loads(request.body)
        question_index_id = data.get('question_id')
        answer_id = data.get('answer_id')

        if not question_index_id or not answer_id:
            return HttpResponseBadRequest("Faltando question_id ou answer_id")

        # --- NOVO BLOCO: aplicar limitação por nível de dificuldade ---
        niveis = NiveisDificuldade.objects.all()
        questoes_filtradas = []
        for nivel in niveis:
            questoes_nivel = (
                Questoes.objects.filter(ativo=True, nivel_dificuldade=nivel.id)
                .order_by('id')[:nivel.maximo_questoes]
            )
            questoes_filtradas.extend(list(questoes_nivel))
        # --------------------------------------------------------------

        question_index = int(question_index_id) - 1

        if question_index < 0 or question_index >= len(questoes_filtradas):
            return JsonResponse(
                {'error': f'O número da questão ({question_index_id}) é inválido.'},
                status=404
            )
        
        questao_obj = questoes_filtradas[question_index]
        real_question_id = questao_obj.id

        selected_answer = Respostas.objects.get(id=answer_id, questao_id=real_question_id)
        correct_answer = Respostas.objects.get(questao_id=real_question_id, correta=True)

        is_correct = (selected_answer.id == correct_answer.id)

        return JsonResponse({
            'is_correct': is_correct,
            'correct_answer_id': correct_answer.id,
            'correct_answer_text': correct_answer.resposta,
            'explicacao': questao_obj.explicacao
        })

    except IndexError:
        return JsonResponse({'error': f'Questão número {question_index_id} não encontrada.'}, status=404)
    except Respostas.DoesNotExist:
        return JsonResponse({'error': 'Resposta ou Questão não encontrada.'}, status=404)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

def index_view(request):
    context = {
        'DEBUG': settings.DEBUG,
    }
    return render(request, 'index.html', context)

@require_http_methods(["POST"])
@ensure_csrf_cookie
def salvar_usuario(request):
    """
    Passo 1: Recebe os dados, valida, GERA um código,
    ENVIA por e-mail e SALVA na sessão (NÃO no banco).
    """
    form = UsuarioForm(request.POST)

    if form.is_valid():
        # Gere um código aleatório de 6 dígitos
        codigo = "{:06d}".format(random.randint(0, 999999))
        email_para = form.cleaned_data.get('email')

        # Tente enviar o e-mail
        try:
            subject = 'Your verification code.'
            message = f'Hi! Your verification code is: {codigo}\nThis code expires within 10 minutes.'
            from_email = settings.EMAIL_HOST_USER # Configurado no settings.py

            send_mail(subject, message, from_email, [email_para])

        except Exception as e:
            # TODO: Logar o erro 'e' para depuração
            return JsonResponse({
                'status': 'error',
                'message': 'Falha ao enviar o e-mail de verificação. Tente novamente.'
            }, status=500)

        # Salve os dados na sessão, não no banco
        request.session['verification_code'] = codigo
        request.session['registration_data'] = form.cleaned_data # Salva os dados do form
        request.session.set_expiry(600) # Código expira em 10 minutos (600 segundos)

        # Avise o front-end que o código foi enviado
        return JsonResponse({
            'status': 'code_sent',
            'message': 'Enviamos um código de 6 dígitos para o seu e-mail.'
        })
    else:
        # Erros de formulário (ex: e-mail inválido, já existe, etc.)
        return JsonResponse({
            'status': 'error',
            'errors': form.errors.get_json_data()
        }, status=400)


@require_http_methods(["POST"])
@ensure_csrf_cookie
def verificar_e_salvar(request):
    """
    Passo 2: Recebe o código de verificação. Se for válido,
    recupera os dados da sessão e cria o usuário no banco.
    """
    try:
        # Assumindo que o front-end envia: {'code': '123456'}
        data = json.loads(request.body)
        user_code = data.get('code')
    except json.JSONDecodeError:
        return JsonResponse({'status': 'error', 'message': 'Requisição mal formatada.'}, status=400)

    # Obtenha os dados da sessão
    session_code = request.session.get('verification_code')
    reg_data = request.session.get('registration_data')

    # Verifique se a sessão não expirou
    if not session_code or not reg_data:
        return JsonResponse({
            'status': 'error',
            'message': 'Sua sessão expirou. Por favor, envie seus dados novamente.'
        }, status=400)

    if user_code == session_code:
        form = UsuarioForm(reg_data)

        if form.is_valid():
            novo_usuario = form.save(commit=False)
            novo_usuario.criado_em = timezone.now()
            novo_usuario.save() # Agora sim, salvamos no banco!

            # Limpe a sessão para não ser usada de novo
            del request.session['verification_code']
            del request.session['registration_data']

            return JsonResponse({
                'status': 'success',
                'message': 'Cadastro realizado com sucesso!'
            })
        else:
            # Raro: Ocorreu um erro (ex: e-mail pego por outro)
            return JsonResponse({
                'status': 'error',
                'errors': form.errors.get_json_data()
            }, status=400)
    else:
        # Código incorreto
        return JsonResponse({
            'status': 'error',
            'message': 'Invalid verification code.'
        }, status=400)