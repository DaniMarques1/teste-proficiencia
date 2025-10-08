from django.shortcuts import render
from django.http import JsonResponse, HttpResponseForbidden
from django.forms.models import model_to_dict  
from questoes.models import Professores, Questoes  
from contas.models import Usuarios
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
import json

def get_teacher(request, teacher_id):
    #Busca um professor pela sua ordem sequencial, não pelo seu ID real, consultando diretamente o banco de dados.

    #if request.headers.get('sec-fetch-site') != 'same-origin':
    #    return HttpResponseForbidden("Forbidden")

    professores_queryset = Professores.objects.order_by('id')
    teacher_index = teacher_id - 1
    
    try:
        professor_obj = professores_queryset[teacher_index]        
        teacher_dict = model_to_dict(professor_obj)
        return JsonResponse(teacher_dict)

    except IndexError:
        return JsonResponse({'error': f'Teacher number {teacher_id} not found.'}, status=404)

def get_teachers(request):
    #Retorna a lista completa de professores como JSON, buscando os dados diretamente do banco.
    #if request.headers.get('sec-fetch-site') != 'same-origin':
    #    return HttpResponseForbidden("Forbidden")
    
    professores = Professores.objects.all()
    data = [model_to_dict(p) for p in professores]
    
    return JsonResponse(data, safe=False)

def get_question(request, question_id):
    # Busca uma questão e suas respectivas respostas pela ordem sequencial.
    # if request.headers.get('sec-fetch-site') != 'same-origin':
    #    return HttpResponseForbidden("Forbidden")

    quantidade_questoes = 3
    questoes_queryset = Questoes.objects.prefetch_related('respostas_set').order_by('id')[:quantidade_questoes]
    question_index = question_id - 1
    
    try:
        questao_obj = questoes_queryset[question_index]
        question_data = model_to_dict(questao_obj)
        respostas_queryset = questao_obj.respostas_set.all()
        respostas_data = [model_to_dict(r) for r in respostas_queryset]
        question_data['respostas'] = respostas_data
        
        return JsonResponse(question_data)

    except IndexError:
        return JsonResponse({'error': f'Question number {question_id} not found.'}, status=404)

def index_view(request):
    return render(request, 'index.html')

@csrf_exempt # Use para testes. Em produção, configure o CSRF token no seu JavaScript.
@require_http_methods(["POST"]) # Garante que esta view só aceite requisições POST
def salvar_usuario(request):
    """
    Recebe os dados do formulário via POST e salva um novo usuário no banco de dados.
    """
    try:
        # request.POST é usado para dados de formulário enviados via 'multipart/form-data' ou 'x-www-form-urlencoded'
        nome = request.POST.get('name')
        email = request.POST.get('email')

        aceita_contato = request.POST.get('aceita_contato') == 'true'

        if not nome or not email:
            return JsonResponse({'status': 'error', 'message': 'Name and e-mail required.'}, status=400)

        # Verifica se o email já está cadastrado para evitar erro de violação de chave única
        if Usuarios.objects.filter(email=email).exists():
            return JsonResponse({'status': 'error', 'message': 'This email is already registered.'}, status=409) # 409 Conflict

        # Cria a nova entrada no banco de dados
        novo_usuario = Usuarios.objects.create(
            nome=nome,
            email=email,
            aceita_contato=aceita_contato,
            criado_em=timezone.now() # Adiciona a data e hora atuais
        )

        # Retorna uma resposta de sucesso
        return JsonResponse({'status': 'success', 'message': f'Success'})

    except Exception as e:
        # Em caso de qualquer outro erro, retorna uma mensagem genérica
        return JsonResponse({'status': 'error', 'message': f'Ocorreu um erro no servidor: {str(e)}'}, status=500)