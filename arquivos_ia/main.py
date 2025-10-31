import os
import json
import datetime
import time
from jinja2 import Environment, FileSystemLoader
from weasyprint import HTML
import os
from dotenv import load_dotenv
import openai

load_dotenv()

# credenciais
OPENAI_KEY = os.getenv('OPENAI_KEY')
openai.api_key = OPENAI_KEY

nota_final = 30
nivel = "Intermediário Superior"

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
}]

respostas = ['Question: Qual é a tradução correta de "house" em português? Your answer: Casa',
             'Question: Complete a frase: Eu ____ ao Brasil no ano passado.Your answer: fui',
             'Question: Qual das opções está no plural? Your answer: Livros']

history_modelo.append({'role': 'user', 'content': "\n".join(respostas)})




# resposta do modelo
def avaliacao_modelo__gpt(history):
    print('entrou')
    openai.api_key = OPENAI_KEY
    openai.api_base = "https://api.openai.com/v1"
    response = openai.ChatCompletion.create(
        model="gpt-4o-mini",
        messages=history
    )
    
    return response.choices[0].message.content



max_tentativas = 3
resposta_final = {}
sucesso = False

for tentativa in range(max_tentativas):
    print('Iniciando tentativas')

    try:
        resposta_ia = avaliacao_modelo__gpt(history_modelo)
        print(resposta_ia)

        resposta_final = json.loads(resposta_ia)

        print("Sucesso! JSON analisado corretamente.")
        sucesso = True
        break


    except json.JSONDecodeError:
        print(f"Erro na tentativa {tentativa + 1}: A resposta da IA não é um JSON válido.")

        if tentativa < max_tentativas - 1:
            time.sleep(1)
            print("Tentando novamente...")

        else:
            print("Número máximo de tentativas atingido. Desistindo.")


if not sucesso:
    resposta_final = {
        "pontos_fortes": "Falha ao analisar a resposta da API após múltiplas tentativas.",
        "pontos_a_melhorar": "Falha ao analisar a resposta da API após múltiplas tentativas."
    }




print("Iniciando a geração do relatório...")

script_dir = os.path.dirname(os.path.abspath(__file__))



dados_aluno = {
    "nome_aluno": "Rafael Souza", 
    **resposta_final,
    "nivel": nivel,
    "nota_final": nota_final,
    "data_emissao": datetime.date.today().strftime('%d de %B de %Y')}

env = Environment(loader=FileSystemLoader(script_dir))
template = env.get_template('template.html')

html_final = template.render(dados_aluno)
print("Template HTML renderizado com sucesso.")

pdf_file = os.path.join(script_dir, 'Relatorio_Retrato.pdf')
base_url = script_dir

# A opção media='print' garante que as regras @media print do CSS sejam aplicadas.
# A orientação padrão do WeasyPrint é retrato, então não precisamos especificar 'orientation'.
HTML(string=html_final, base_url=base_url).write_pdf(pdf_file, presentational_hints=True, media='print')

print(f"PDF '{pdf_file}' gerado com sucesso!")