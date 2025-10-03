from django.shortcuts import render
from django.http import JsonResponse, HttpResponseForbidden
from django.forms.models import model_to_dict  
from questoes.models import Professores, Questoes  

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

