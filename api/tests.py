from django.test import TestCase, override_settings, tag
from django.core.mail import send_mail

@tag('integration') # Marca este teste como 'integration'
@override_settings(EMAIL_BACKEND='django.core.mail.backends.smtp.EmailBackend')
class RealEmailSendingIntegrationTest(TestCase):
    
    def test_real_email_sending(self):
        """
        Este teste envia um e-mail de verdade. Use com moderação.
        """
        try:
            sent_count = send_mail(
                subject='Teste de Integração - E-mail Real enviado pela aplicação',
                message='Este e-mail foi enviado por um teste automatizado, app django pi - 2 teste proficiencia.',
                from_email=None,  # Usa o DEFAULT_FROM_EMAIL das configurações
                recipient_list=['daniel.13.marques.18@gmail.com'], # Coloque seu e-mail aqui
                fail_silently=False,
            )
            self.assertEqual(sent_count, 1)
        except Exception as e:
            self.fail(f"O envio de e-mail real falhou com a exceção: {e}")