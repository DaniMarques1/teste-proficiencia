from django.db import models

class NiveisDificuldade(models.Model):
    id = models.IntegerField(primary_key=True)
    nivel = models.CharField(unique=True, max_length=50)
    peso = models.DecimalField(max_digits=5, decimal_places=2)
    maximo_questoes = models.IntegerField(default=0)

    class Meta:
        managed = False
        db_table = 'niveis_dificuldade'
        verbose_name = 'Nível de Dificuldade'
        verbose_name_plural = 'Níveis de Dificuldade'


class Professores(models.Model):
    nome = models.CharField(max_length=100)
    email = models.CharField(unique=True, max_length=100)
    telefone = models.CharField(max_length=20, blank=True, null=True)
    foto_url = models.CharField(max_length=550, blank=True, null=True)
    linguas = models.CharField(max_length=225, blank=True, null=True)
    texto = models.CharField(max_length=4000, blank=True, null=True)
    link = models.CharField(max_length=550, blank=True, null=True)
    criado_em = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'professores'
        verbose_name = 'Professor'
        verbose_name_plural = 'Professores'


class Questoes(models.Model):
    TIPO_UNICA = 'unica'
    TIPO_MULTIPLA = 'multipla'
    TIPO_DISSERTATIVA = 'dissertativa'

    TIPO_CHOICES = [
        (TIPO_UNICA, 'Única Escolha'),
        (TIPO_MULTIPLA, 'Múltipla Escolha'),
        (TIPO_DISSERTATIVA, 'Dissertativa'),
    ]
    
    questao = models.CharField(max_length=10)
    texto = models.TextField()
    tipo = models.CharField(max_length=12, choices=TIPO_CHOICES, default=TIPO_UNICA,)
    nivel_dificuldade = models.IntegerField()
    explicacao = models.CharField(max_length=512)
    microfone = models.BooleanField(default=False)
    criado_em = models.DateTimeField(blank=True, null=True)
    atualizado_em = models.DateTimeField(blank=True, null=True)
    ativo = models.BooleanField(default=True)

    class Meta:
        managed = False
        db_table = 'questoes'
        verbose_name = 'Questão'
        verbose_name_plural = 'Questões'


class Respostas(models.Model):
    questao = models.ForeignKey(Questoes, models.DO_NOTHING)
    resposta = models.CharField(max_length=255)
    correta = models.BooleanField(default=False)
    ordem = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'respostas'
        verbose_name = 'Resposta'
        verbose_name_plural = 'Respostas'

