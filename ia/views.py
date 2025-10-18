import os
import json
import datetime
import time
from django.http import JsonResponse, HttpResponse
from django.views.decorators.csrf import csrf_exempt
from jinja2 import Environment, FileSystemLoader
from weasyprint import HTML
from dotenv import load_dotenv
import openai

# Carregar variáveis de ambiente
load_dotenv()

# Credenciais
OPENAI_KEY = os.getenv('OPENAI_KEY')
openai.api_key = OPENAI_KEY


def avaliacao_modelo__gpt(history):
    """Envia o histórico para o modelo e retorna a resposta como string."""
    response = openai.ChatCompletion.create(
        model="gpt-4o-mini",
        messages=history
    )
    return response.choices[0].message.content


@csrf_exempt
def gerar_relatorio(request):
    """View principal: gera um relatório PDF com avaliação automática."""
    if request.method != "POST":
        return JsonResponse({"erro": "Método não permitido. Use POST."}, status=405)

    try:
        # Dados simulados — podem vir via request.POST futuramente
        respostas = [
            'Question: Qual é a tradução correta de "house" em português? Your answer: Casa',
            'Question: Complete a frase: Eu ____ ao Brasil no ano passado.Your answer: fui',
            'Question: Qual das opções está no plural? Your answer: Livros'
        ]
        nivel = "A1 Intermediário"
        nota_final = 30

        # Histórico da conversa
        history_modelo = [{
            "role": "system",
                "content": """Você é um avaliador de proficiência na lingua portuguesa;
                você receberá quertões com as respostas que o aluno assinalou no teste
                Você deverá responder a duas questões: 
                quais os 3 pontos fortes do avaliado em relação ao idioma português?; e 
                quais são os 3 pontos a melhorar que o avaliado deve estudar para melhorar em relação ao idioma português?
                
                Sua resposta deve seguir a seguinte estrutura, deve possuir exatamente 3 pontos fortes e 3 pontos a desenvolver:
                {"pontos_fortes": [
                    "Excelente domínio de estruturas complexas na escrita formal.",
                    "Compreensão auditiva apurada, capaz de entender nuances e sotaques variados.",
                    "Fluidez e confiança notáveis na comunicação oral sobre temas familiares."
                ],
                "pontos_a_desenvolver": [
                    "Uso de vocabulário mais específico em contextos técnicos ou de negócios.",
                    "Maior atenção aos tempos verbais subjuntivos em cenários hipotéticos."
                ]}
                
                """
        }, {
            "role": "user",
            "content": "\n".join(respostas)
        }]

        # Tentativas com tratamento de erro
        max_tentativas = 3
        sucesso = False
        resposta_final = {}

        for tentativa in range(max_tentativas):
            try:
                resposta_ia = avaliacao_modelo__gpt(history_modelo)
                resposta_final = json.loads(resposta_ia)
                sucesso = True
                break
            except json.JSONDecodeError:
                if tentativa < max_tentativas - 1:
                    time.sleep(1)
                else:
                    resposta_final = {
                        "pontos_fortes": ["Falha ao analisar a resposta da API."],
                        "pontos_a_desenvolver": ["Falha ao analisar a resposta da API."]
                    }

        # Montar dados para o template
        script_dir = os.path.dirname(os.path.abspath(__file__))
        dados_aluno = {
            "nome_aluno": "Rafael Souza",
            **resposta_final,
            "nivel": nivel,
            "nota_final": nota_final,
            "data_emissao": datetime.date.today().strftime('%d de %B de %Y')
        }

        # Renderizar HTML e gerar PDF
        env = Environment(loader=FileSystemLoader(script_dir))
        template = env.get_template('template.html')
        html_final = template.render(dados_aluno)

        pdf_file = os.path.join(script_dir, 'Relatorio_Retrato.pdf')
        HTML(string=html_final, base_url=script_dir).write_pdf(pdf_file, presentational_hints=True, media='print')

        # Retornar PDF na resposta
        with open(pdf_file, 'rb') as f:
            response = HttpResponse(f.read(), content_type='application/pdf')
            response['Content-Disposition'] = 'attachment; filename="Relatorio_Retrato.pdf"'
            return response

    except Exception as e:
        return JsonResponse({"erro": str(e)}, status=500)
