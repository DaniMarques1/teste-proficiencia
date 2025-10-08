# api/urls.py
from django.urls import path
from . import views
from api.views import index_view

urlpatterns = [
    path('question/<int:question_id>/', views.get_question, name='get_question'),
    path('teachers/', views.get_teachers, name='get_teachers'),
    path('teacher/<int:teacher_id>/', views.get_teacher, name='get_teacher'),
    path('api/salvar-usuario/', views.salvar_usuario, name='salvar_usuario'),
    path('api/check-answer/', views.check_answer, name='check_answer'),
]