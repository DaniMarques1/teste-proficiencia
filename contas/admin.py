from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import Adm, Usuarios  # Importe seu modelo Adm personalizado
from django.contrib.auth.models import Group
import csv
import datetime
from django.http import HttpResponse

# --- FUNÇÃO DE AÇÃO PARA EXPORTAR ---
def exportar_para_csv(modeladmin, request, queryset):
    """
    Ação do Admin que exporta os itens selecionados do modelo 'Usuarios' para CSV.
    """
    # Pega os metadados do modelo para usar no nome do arquivo
    opts = modeladmin.model._meta
    model_name = opts.verbose_name_plural.lower().replace(' ', '_')
    
    # Prepara a resposta HTTP
    response = HttpResponse(content_type='text/csv')
    # Define o charset para UTF-8 para lidar com acentos
    response.write(u'\ufeff'.encode('utf8'))
    response['Content-Disposition'] = f'attachment; filename="{model_name}_export_{datetime.date.today()}.csv"'
    
    # Define o "escritor" CSV
    writer = csv.writer(response)
    
    # --- Defina os campos que você quer no CSV ---
    # Usei os campos do seu list_display para 'Usuarios'
    field_names = ['id', 'nome', 'email', 'aceita_contato', 'criado_em']
    
    # 1. Escreve a linha de cabeçalho (Header)
    writer.writerow(field_names)
    
    # 2. Escreve as linhas de dados
    for obj in queryset:
        row = [getattr(obj, field) for field in field_names]
        writer.writerow(row)
        
    return response

# Define o nome que aparecerá no menu dropdown de Ações
exportar_para_csv.short_description = "Exportar selecionados para CSV"
# --- FIM DA FUNÇÃO DE AÇÃO ---


# Registra o modelo Adm usando a configuração padrão do UserAdmin
@admin.register(Adm)
class AdmAdmin(UserAdmin):
    pass

@admin.register(Usuarios)
class UsuariosAdmin(admin.ModelAdmin):
    list_display = ('id', 'nome', 'email', 'aceita_contato', 'criado_em')
    search_fields = ('nome', 'email')
    list_filter = ('aceita_contato',)
    
    # Vincula a nova ação a este ModelAdmin
    actions = [exportar_para_csv]


admin.site.unregister(Group)