import os
import json
import datetime
import time
import io  # Para manipulação de bytes em memória
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.core.mail import EmailMessage  # Para enviar e-mail com anexo
from jinja2 import Environment, FileSystemLoader
from weasyprint import HTML
from dotenv import load_dotenv
import openai

load_dotenv()

OPENAI_KEY = os.getenv('OPENAI_KEY')
openai.api_key = OPENAI_KEY

EMAIL_PADRAO_RELATORIO = None

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
    Se solicitado, gera um PDF em memória e o envia por e-mail
    para o destinatário fornecido ou para um e-mail padrão.
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
        
        # Obter o e-mail (pode ser None)
        email_destinatario = data.get("email_destinatario", None)

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

        # 4. Se a geração de PDF (e envio de e-mail) foi solicitada
        if quer_pdf:
            
            email_para_envio = email_destinatario
            aviso_json = ""
            
            if not email_destinatario:
                # Se nenhum e-mail foi fornecido no payload, usa o e-mail padrão
                email_para_envio = EMAIL_PADRAO_RELATORIO
                aviso_json = f"Nenhum destinatário fornecido. E-mail enviado para o endereço padrão."
                print(aviso_json) # Log no servidor
            

            script_dir = os.path.dirname(os.path.abspath(__file__))
            
            # Contexto completo para o template do PDF
            dados_template = {
                "nome_aluno": nome_aluno,
                **resposta_final,
                "nivel": nivel,
                "nota_final": nota_final,
                "data_emissao": datetime.date.today().strftime('%d de %B de %Y')
            }

            # Renderiza o HTML
            env = Environment(loader=FileSystemLoader(script_dir))
            template = env.get_template('template.html')
            html_final = template.render(dados_template)
            
            # Gera um nome de arquivo único para o anexo
            timestamp = int(time.time())
            nome_arquivo_pdf = f'relatorio_{nome_aluno.replace(" ", "_")}_{timestamp}.pdf'

            # --- GERAÇÃO DO PDF EM MEMÓRIA ---
            
            pdf_buffer = io.BytesIO()
            HTML(string=html_final, base_url=script_dir).write_pdf(
                pdf_buffer,
                presentational_hints=True
            )
            pdf_bytes = pdf_buffer.getvalue()
            pdf_buffer.close()

            # --- ENVIO DO E-MAIL COM O PDF EM MEMÓRIA ---
            try:
                email_remetente = os.getenv('EMAIL_HOST_USER') 
                
                email = EmailMessage(
                    subject="Congratulations on completing your Portuguese quiz! 🎉",
                    body=f"Hi, {nome_aluno}!\n\nCongratulations on completing your Portuguese quiz!\n\nAttached, you’ll find a summary of your results — great work! \n\nReady to keep improving? Schedule your next Portuguese lesson at bestwayportuguese.com and continue your learning journey with us. \n\n \n\nSee you soon, \n\nThe Best Way Portuguese Team",
                    from_email=email_remetente,
                    to=[email_para_envio] 
                )
                
                email.attach(
                    nome_arquivo_pdf,
                    pdf_bytes,
                    'application/pdf'
                )
                
                email.send()
                
                # Adiciona feedback de sucesso no JSON
                resposta_final["email_enviado"] = email_para_envio
                if aviso_json:
                    resposta_final["aviso_envio"] = aviso_json

            except Exception as e:
                print(f"Erro ao enviar e-mail: {e}")
                # Adiciona feedback de erro no JSON
                resposta_final["erro_email"] = f"A análise foi gerada, mas falhou ao enviar o e-mail: {str(e)}"

        # 5. Retorne SEMPRE a resposta JSON para o frontend
        return JsonResponse(resposta_final, status=200)

    except json.JSONDecodeError:
        return JsonResponse({"erro": "Payload JSON inválido."}, status=400)
    except Exception as e:
        print(f"Erro inesperado na view: {e}")
        return JsonResponse({"erro": "Ocorreu um erro interno no servidor."}, status=500)