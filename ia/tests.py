from django.test import TestCase, RequestFactory
from .views import gerar_relatorio

class GerarRelatorioTest(TestCase):
    def setUp(self):
        self.factory = RequestFactory()

    def test_gera_pdf(self):
        request = self.factory.post('/gerar_relatorio/')
        response = gerar_relatorio(request)

        # Mostra no terminal o que veio
        print("Status code:", response.status_code)
        print("Content-Type:", response.get('Content-Type'))

        # Salva o PDF se quiser inspecionar
        with open('teste_output.pdf', 'wb') as f:
            f.write(response.content)

        # Testes básicos
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.get('Content-Type'), 'application/pdf')
