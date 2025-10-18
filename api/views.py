from django.shortcuts import render
from django.http import JsonResponse, HttpResponseForbidden
from django.forms.models import model_to_dict  
from questoes.models import Professores, Questoes, Respostas
from contas.models import Usuarios
from django.http import JsonResponse, HttpResponseBadRequest
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from contas.forms import UsuarioForm
from django.views.decorators.csrf import ensure_csrf_cookie
import json

def get_teacher(request, teacher_id):
    teacher_index = teacher_id - 1
    
    try:
        professor_obj = professores_queryset[teacher_index]        
        teacher_dict = model_to_dict(professor_obj)
        return JsonResponse(teacher_dict)

    except IndexError:
        return JsonResponse({'error': f'Teacher number {teacher_id} not found.'}, status=404)

def get_teachers(request): 
    professores = Professores.objects.all()
    data = [model_to_dict(p) for p in professores]
    
    return JsonResponse(data, safe=False)

def get_question(request, question_id):
    # Agora filtramos por todas as questões que estão ativas.
    questoes_queryset = Questoes.objects.filter(ativo=True).prefetch_related('respostas_set').order_by('id')
    
    question_index = question_id - 1
    
    try:
        questao_obj = questoes_queryset[question_index]
        
        # ALTERAÇÃO: Usamos 'exclude' para omitir o campo 'explicacao'
        question_data = model_to_dict(questao_obj, exclude=['explicacao'])

        respostas_queryset = questao_obj.respostas_set.all()
        respostas_data = []
        for r in respostas_queryset:
            respostas_data.append({
                'id': r.id,
                'resposta': r.resposta,
                'questao': r.questao.id
            })

        question_data['respostas'] = respostas_data

        return JsonResponse(question_data)

    except IndexError:
        return JsonResponse({'error': f'Question number {question_id} not found among active questions.'}, status=404)
    
@require_http_methods(["POST"])
@csrf_exempt
def check_answer(request):
    try:
        data = json.loads(request.body)
        question_index_id = data.get('question_id')
        answer_id = data.get('answer_id')

        if not question_index_id or not answer_id:
            return HttpResponseBadRequest("Faltando question_id ou answer_id")

        questoes_queryset = Questoes.objects.filter(ativo=True).order_by('id')
        question_index = int(question_index_id) - 1

        if question_index < 0:
            return JsonResponse({'error': f'O número da questão ({question_index_id}) é inválido.'}, status=404)
        
        questao_obj = questoes_queryset[question_index]
        
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
    return render(request, 'index.html')

@require_http_methods(["POST"])
@ensure_csrf_cookie
def salvar_usuario(request):
    """
    Recebe os dados via POST, valida com o UsuarioForm e salva no banco.
    """
    form = UsuarioForm(request.POST)

    if form.is_valid():
        novo_usuario = form.save(commit=False)
        novo_usuario.criado_em = timezone.now()
        novo_usuario.save() # Agora salva no banco

        return JsonResponse({
            'status': 'success',
            'message': 'Cadastro realizado com sucesso!'
        })
    else:
        return JsonResponse({
            'status': 'error',
            'errors': form.errors.get_json_data()
        }, status=400) 