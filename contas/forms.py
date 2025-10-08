from django import forms
from .models import Usuarios

class UsuarioForm(forms.ModelForm):
    class Meta:
        model = Usuarios
        fields = ['nome', 'email', 'aceita_contato']

    def clean_email(self):
        email = self.cleaned_data.get('email')
        if Usuarios.objects.filter(email__iexact=email).exists():
            raise forms.ValidationError("This e-mail is already registered.")
        return email