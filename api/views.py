# api/views.py
from django.shortcuts import render
from django.http import JsonResponse, HttpResponseForbidden
from .data import QUESTIONS_DB

def get_question(request, question_id):
    question = next((q for q in QUESTIONS_DB if q['id'] == question_id), None)

    if request.headers.get('sec-fetch-site') != 'same-origin':
        return HttpResponseForbidden("Forbidden")
    
    if question is None:
        return JsonResponse({'error': f'Question with id {question_id} not found.'}, status=404)
        
    return JsonResponse(question)

def index_view(request):
    return render(request, 'index.html')