# PI 2 UNIVESP - Quiz para detectar o nível de proficiencia Português-Inglês

## Objetivo
Desenvolver uma aplicação web com integração de inteligência artificial para identificar o nível de proficiência em português de falantes estrangeiros, especialmente nativos da língua inglesa.

## Resumo do sistema:
- 📜Quiz com perguntas em 3 dificuldades, para avaliar proficiência em Português.
- 🥇Telas de feedback e resultados das perguntas, mostrando acertos e erros, além de explicação para a resposta correta.
- ✉️Integração de e-mail para entrar no quiz e para receber o resultado.
- 🤖Integração com a IA para gerar feedback personalizado (condizente com as respostas do usuário).
- 🧠Cálculo de nível de proficiência.
- 📝Acesso ao banco de dados por meio de um dashboard integrado, sendo possível edição, adição e exclusão das perguntas e respostas, possibilidade de definir a quantidade de questões por dificuldade, além de acesso à outras tabelas do sistema.
- 🧑‍🏫Indicação para professores da plataforma.

----------------------------------------------------------

### Como instalar:

- O Python deve estar instalado em sua máquina. Na instalação do Python no Windows, marque a caixa *Add python.exe to PATH*.

1 - Baixe ou clone o repositório git.

```bash
git clone https://github.com/DaniMarques1/teste-proficiencia.git
```

2 - Acesse a pasta *teste-proficiencia*.

3 - Dentro da pasta, abra o prompt de comando e crie o ambiente virtual *venv* (Virtual Environment):
```bash
py -m venv venv
```

4 - Ative o venv:
```bash
venv/Scripts/activate
```

5 - Instale as bibliotecas (requirements.txt)
```bash
pip install -r requirements.txt
```

6 - Na pasta principal, crie um arquivo nomeado ".env" para armazenar as seguintes variáveis de ambiente:
```bash 
DB_ENGINE=django.db.backends.mysql
DB_NAME=pi_proficiencia
DB_USER=seuUsernameMYSQL
DB_PASSWORD=suaSenhaMYSQL
DB_HOST=127.0.0.1
DB_PORT=3306
DEBUG=True
ALLOWED_HOSTS=127.0.0.1,localhost
EMAIL_HOST_USER=seuEnderecoDeEmail
EMAIL_HOST_PASSWORD=suaSenhaDoEmail
OPENAI_KEY=suaChaveOpenAI
```

7 - Crie o database MySQL utilizando o arquivo "pi_proficiencia.sql".

8 - Inicie o servidor Django:
```bash
py manage.py runserver
```

----------------------------------------------------------

### Backend

- Python
- Django
- Javascript
- MySQL

#### Frontend

- HTML/CSS
- Javascript

# Estrutura do projeto explicada

![Estrutura da Página](static/img/estrutura_pagina.png)



