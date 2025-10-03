from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import Adm, Usuarios  # Importe seu modelo Adm personalizado
from django.contrib.auth.models import Group

# Registra o modelo Adm usando a configuração padrão do UserAdmin
@admin.register(Adm)
class AdmAdmin(UserAdmin):
    pass

@admin.register(Usuarios)
class UsuariosAdmin(admin.ModelAdmin):
    list_display = ('id', 'nome', 'email', 'aceita_contato', 'criado_em') # ID adicionado
    search_fields = ('nome', 'email')
    list_filter = ('aceita_contato',)

admin.site.unregister(Group)