# api/views.py
from django.shortcuts import render
from django.http import JsonResponse, HttpResponseForbidden

QUESTIONS_DB = [
    {
        "id": 1,
        "header": "The Basics",
        "level": 0,
        "question": "Olá",
        "answer": ["Hello", "Hi"],
    },
    {
        "id": 2,
        "header": "The Basics",
        "level": 0,
        "question": "Tchau",
        "answer": ["Bye", "Good bye"],
    },
    {
        "id": 3,
        "header": "Politeness",
        "level": 1,
        "question": "Obrigado",
        "answer": ["Thank you", "Thanks"],
    }
]

def get_question(request, question_id):
    question = next((q for q in QUESTIONS_DB if q['id'] == question_id), None)

    if request.headers.get('sec-fetch-site') != 'same-origin':
        return HttpResponseForbidden("Forbidden")
    
    if question is None:
        return JsonResponse({'error': f'Question with id {question_id} not found.'}, status=404)
        
    return JsonResponse(question)

def index_view(request):
    return render(request, 'index.html')