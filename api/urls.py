# api/urls.py
from django.urls import path
from . import views
from api.views import index_view

urlpatterns = [
    path('api/question/<int:question_id>/', views.get_question, name='get_question'),
    path('api/teachers/', views.get_teachers, name='get_teachers'),
    path('api/teacher/<int:teacher_id>/', views.get_teacher, name='get_teacher'),
    path('api/salvar-usuario/', views.salvar_usuario, name='salvar_usuario'),
    path('api/check-answer/', views.check_answer, name='check_answer'),
    path('api/verificar-codigo/', views.verificar_e_salvar, name='verificar_e_salvar'),
]