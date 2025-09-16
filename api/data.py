# Este arquivo serve como um "banco de dados" temporário em memória.
# No futuro, os dados virão do banco de dados real.

QUESTIONS_DB = [
    {
        "id": 1,
        "header": "The Basics",
        "level": 0,
        "texto": "Traduza a seguinte palavraSS:",
        "questao": "Olá",
        "tipo": "texto",
        "answer": ["Hello", "Hi"],
    },
    {
        "id": 2,
        "header": "The Basics",
        "level": 0,
        "texto": "Traduza a seguinte palavra:",
        "questao": "Tchau",
        "tipo": "texto",
        "answer": ["Bye", "Good bye"],
    },
    {
    "id": 3,
    "header": "Politeness",
    "level": 1,
    "texto": "Escolha a resposta correta:",
    "questao": "What is the meaning of the word Obrigado",
    "tipo": "multipla-escolha",
    "respostas": [
        { "id": 1, "texto": "You're welcome", "correta": False },
        { "id": 2, "texto": "Thank you", "correta": True },
        { "id": 3, "texto": "Please", "correta": False },
        { "id": 4, "texto": "Sorry", "correta": False }
    ]
    }
]

professores_db = [
    {
        "id": 1,
        "nome": "Ana Clara",
        "email": "ana.clara@prof.bestwayportuguese.com",
        "telefone": "+55 11 98765-4321",
        "criado_em": "2025-09-12T10:30:00"
    },
    {
        "id": 2,
        "nome": "Marcos Oliveira",
        "email": "marcos.o@prof.bestwayportuguese.com",
        "telefone": "+55 21 91234-5678",
        "criado_em": "2025-09-11T15:00:00"
    }
]

questoes_db = [
    {
        "id": 1,
        "texto": "Olá",
        "tipo": "texto", # O usuário digita a tradução
        "nivel": 0,
        "microfone": True,
        "criado_em": "2025-09-10T09:00:00",
        "atualizado_em": "2025-09-10T09:00:00"
    },
    {
        "id": 2,
        "texto": "Qual a tradução de 'maçã'?",
        "tipo": "unica", # O usuário escolhe uma opção
        "nivel": 0,
        "microfone": False,
        "criado_em": "2025-09-11T11:00:00",
        "atualizado_em": "2025-09-11T11:00:00"
    },
    {
        "id": 3,
        "texto": "A frase 'Eu comi pão' está no tempo verbal futuro.",
        "tipo": "verdadeiro_falso", # O usuário escolhe V ou F
        "microfone": False,
        "nivel": 1,
        "criado_em": "2025-09-12T08:30:00",
        "atualizado_em": "2025-09-12T08:30:00"
    }
]

respostas_db = [
    # Respostas para a Questão 1 ("Olá")
    {
        "id": 1,
        "questao_id": 1, # Chave estrangeira ligada à questão "Olá"
        "resposta": "Hello",
        "correta": True,
        "ordem": 0
    },
    {
        "id": 2,
        "questao_id": 1,
        "resposta": "Hi",
        "correta": True,
        "ordem": 0
    },
    # Respostas para a Questão 2 ("Qual a tradução de 'maçã'?")
    {
        "id": 3,
        "questao_id": 2,
        "resposta": "Apple",
        "correta": True,
        "ordem": 0
    },
    {
        "id": 4,
        "questao_id": 2,
        "resposta": "Banana",
        "correta": False,
        "ordem": 0
    },
    {
        "id": 5,
        "questao_id": 2,
        "resposta": "Grape",
        "correta": False,
        "ordem": 0
    },
    # Respostas para a Questão 3 ("A frase 'Eu comi pão' está no futuro.")
    {
        "id": 6,
        "questao_id": 3,
        "resposta": "Falso",
        "correta": True,
        "ordem": 0
    },
    {
        "id": 7,
        "questao_id": 3,
        "resposta": "Verdadeiro",
        "correta": False,
        "ordem": 0
    }
]