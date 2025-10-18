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
    """
    View principal: gera um relatório com avaliação automática.
    Sempre retorna um JSON com a análise da IA.
    Se solicitado, também salva um PDF completo no servidor.
    """
    if request.method != "POST":
        return JsonResponse({"erro": "Método não permitido. Use POST."}, status=405)

    try:
        # 1. Ler o corpo da requisição
        data = json.loads(request.body)

        # 2. Extrair os dados do payload
        nome_aluno = data.get("nome_aluno", "Aluno_Anonimo")
        respostas = data.get("respostas", [])
        nivel = data.get("nivel", "Não especificado")
        nota_final = data.get("nota_final", 0)
        quer_pdf = data.get("pdf", False)

        if not respostas:
            return JsonResponse({"erro": "Nenhuma resposta fornecida para análise."}, status=400)

        # 3. Montar e enviar o prompt para a IA
        history_modelo = [
            {
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
                ]}"""
            },
            {
                "role": "user",
                "content": "\n".join(respostas)
            }
        ]

        # Lógica para chamar a IA com retentativas
        max_tentativas = 3
        resposta_final = {}
        for tentativa in range(max_tentativas):
            try:
                resposta_ia = avaliacao_modelo__gpt(history_modelo)
                resposta_final = json.loads(resposta_ia)
                break
            except json.JSONDecodeError:
                if tentativa < max_tentativas - 1:
                    time.sleep(1)
                else:
                    resposta_final = {
                        "pontos_fortes": ["Falha ao analisar a resposta da API."],
                        "pontos_a_desenvolver": ["Falha ao analisar a resposta da API."]
                    }

        # 4. Se a geração de PDF foi solicitada, crie e salve o arquivo
        #    Esta lógica agora é executada ANTES de enviar a resposta final.
        if quer_pdf:
            script_dir = os.path.dirname(os.path.abspath(__file__))
            
            # Contexto completo para o template do PDF
            dados_template = {
                "nome_aluno": nome_aluno,
                **resposta_final,
                "nivel": nivel,
                "nota_final": nota_final,
                "data_emissao": datetime.date.today().strftime('%d de %B de %Y')
            }

            env = Environment(loader=FileSystemLoader(script_dir))
            template = env.get_template('template.html')
            html_final = template.render(dados_template)
            
            # ✅ GERA UM NOME DE ARQUIVO ÚNICO PARA NÃO SOBRESCREVER
            timestamp = int(time.time())
            nome_arquivo_pdf = f'relatorio_{nome_aluno.replace(" ", "_")}_{timestamp}.pdf'

            # Considere criar um diretório 'temp_reports' para organizar os PDFs
            # Ex: pdf_path = os.path.join(script_dir, 'temp_reports', nome_arquivo_pdf)
            pdf_path = os.path.join(script_dir, nome_arquivo_pdf)

            # Salva o PDF no caminho especificado
            HTML(string=html_final, base_url=script_dir).write_pdf(pdf_path, presentational_hints=True)
            
            # Adicionamos uma informação extra no JSON para o frontend saber que o PDF foi gerado
            resposta_final["pdf_gerado"] = nome_arquivo_pdf

        # 5. Retorne SEMPRE a resposta JSON para o frontend
        return JsonResponse(resposta_final, status=200)

    except json.JSONDecodeError:
        return JsonResponse({"erro": "Payload JSON inválido."}, status=400)
    except Exception as e:
        # Para depuração, é bom logar o erro real
        print(f"Erro inesperado: {e}")
        return JsonResponse({"erro": "Ocorreu um erro interno no servidor."}, status=500)