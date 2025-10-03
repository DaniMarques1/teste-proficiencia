from django.contrib import admin
from .models import NiveisDificuldade, Professores, Questoes, Respostas

class RespostasInline(admin.TabularInline):
    model = Respostas
    extra = 1

@admin.register(NiveisDificuldade)
class NiveisDificuldadeAdmin(admin.ModelAdmin):
    list_display = ('id', 'nivel', 'peso') # ID adicionado

@admin.register(Professores)
class ProfessoresAdmin(admin.ModelAdmin):
    list_display = ('id', 'nome', 'email', 'telefone', 'foto_url', 'linguas', 'texto', 'link', 'criado_em') # ID adicionado
    search_fields = ('nome', 'email', 'linguas')
    list_filter = ('linguas',)

@admin.register(Questoes)
class QuestoesAdmin(admin.ModelAdmin):
    list_display = ('id', 'titulo', 'texto', 'tipo', 'nivel_dificuldade', 'criado_em') # ID adicionado
    search_fields = ('titulo', 'texto')
    list_filter = ('tipo', 'nivel_dificuldade')
    inlines = [RespostasInline]