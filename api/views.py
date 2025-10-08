from django.shortcuts import render
from django.http import JsonResponse, HttpResponseForbidden
from django.forms.models import model_to_dict  
from questoes.models import Professores, Questoes  
from contas.models import Usuarios
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from contas.forms import UsuarioForm
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

@require_http_methods(["POST"])
def salvar_usuario(request):
    """
    Recebe os dados via POST, valida com o UsuarioForm e salva no banco.
    """
    # Instancia o formulário com os dados recebidos via POST
    form = UsuarioForm(request.POST)

    # O método is_valid() executa todas as validações (campos obrigatórios, email único, etc.)
    if form.is_valid():
        # O form.save() cria o objeto mas não o salva no banco ainda (commit=False)
        novo_usuario = form.save(commit=False)
        novo_usuario.criado_em = timezone.now()
        novo_usuario.save() # Agora salva no banco

        return JsonResponse({
            'status': 'success',
            'message': 'Cadastro realizado com sucesso!'
        })
    else:
        # Se o formulário for inválido, retorna os erros em um formato JSON
        # form.errors.as_json() cria um JSON com os campos e suas listas de erros
        return JsonResponse({
            'status': 'error',
            'errors': form.errors.get_json_data()
        }, status=400) # status 400 indica um Bad Request