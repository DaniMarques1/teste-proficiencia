from django.contrib import admin
from .models import NiveisDificuldade, Professores, Questoes, Respostas

class RespostasInline(admin.TabularInline):
    model = Respostas
    extra = 1

@admin.register(NiveisDificuldade)
class NiveisDificuldadeAdmin(admin.ModelAdmin):
    list_display = ('id', 'nivel', 'peso') 

@admin.register(Professores)
class ProfessoresAdmin(admin.ModelAdmin):
    list_display = ('id', 'nome', 'email', 'telefone', 'foto_url', 'linguas', 'texto', 'link', 'criado_em') 
    search_fields = ('nome', 'email', 'linguas')
    list_filter = ('linguas',)

@admin.register(Questoes)
class QuestoesAdmin(admin.ModelAdmin):
    list_display = ('id', 'texto', 'tipo', 'nivel_dificuldade', 'criado_em', 'ativo', 'explicacao')
    search_fields = ('texto', 'ativo')
    list_filter = ('tipo', 'nivel_dificuldade', 'ativo')
    inlines = [RespostasInline]
    
    # Adicione a linha abaixo para registrar suas novas ações
    actions = ['ativar_questoes', 'desativar_questoes']

    # Ação para ATIVAR as questões selecionadas
    def ativar_questoes(self, request, queryset):
        queryset.update(ativo=True)
        self.message_user(request, "As questões selecionadas foram ativadas com sucesso.")
    ativar_questoes.short_description = "Ativar Questões selecionadas"

    # Ação para DESATIVAR as questões selecionadas
    def desativar_questoes(self, request, queryset):
        queryset.update(ativo=False)
        self.message_user(request, "As questões selecionadas foram desativadas com sucesso.")
    desativar_questoes.short_description = "Desativar Questões selecionadas"
