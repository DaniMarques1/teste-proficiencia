from django.contrib.auth.models import AbstractUser
from django.db import models

class Adm(AbstractUser):
    class Meta:
        db_table = 'adm'
        verbose_name = "Administrador"
        verbose_name_plural = "Administradores"
        
class Usuarios(models.Model):
    nome = models.CharField(max_length=100)
    email = models.CharField(unique=True, max_length=100)
    aceita_contato = models.BooleanField(default=False)
    criado_em = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'usuarios'
        verbose_name = 'Usuário'
        verbose_name_plural = 'Usuários'