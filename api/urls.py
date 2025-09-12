# api/urls.py
from django.urls import path
from . import views
from api.views import index_view

urlpatterns = [
    path('question/<int:question_id>/', views.get_question, name='get_question'),
]