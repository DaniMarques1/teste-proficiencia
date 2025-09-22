# api/views.py
from django.shortcuts import render
from django.http import JsonResponse, HttpResponseForbidden
# 1. Importe a nova lista de professores
from .data import QUESTIONS_DB, PROFESSORES_DB

def get_question(request, question_id):
    question = next((q for q in QUESTIONS_DB if q['id'] == question_id), None)

    if request.headers.get('sec-fetch-site') != 'same-origin':
        return HttpResponseForbidden("Forbidden")
    
    if question is None:
        return JsonResponse({'error': f'Question with id {question_id} not found.'}, status=404)
        
    return JsonResponse(question)


def get_teacher(request, teacher_id):
    teacher = next((q for q in PROFESSORES_DB if q['id'] == teacher_id), None)

    if request.headers.get('sec-fetch-site') != 'same-origin':
        return HttpResponseForbidden("Forbidden")
    
    if teacher is None:
        return JsonResponse({'error': f'Question with id {teacher_id} not found.'}, status=404)
        
    return JsonResponse(teacher)

def get_teachers(request):
    """
    Retorna a lista completa de professores como JSON.
    """
    if request.headers.get('sec-fetch-site') != 'same-origin':
        return HttpResponseForbidden("Forbidden")
    
    # O 'safe=False' é necessário para permitir que uma lista seja enviada como resposta JSON
    return JsonResponse(PROFESSORES_DB, safe=False)

def index_view(request):
    return render(request, 'index.html')