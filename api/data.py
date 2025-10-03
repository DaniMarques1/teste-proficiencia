# Este arquivo serve como um "banco de dados" temporário em memória.
# No futuro, os dados virão do banco de dados real.

QUESTIONS_DB = [
    {
        "id": 1,
        "titulo": "The Basics",
        "nivel_dificuldade": 0,
        "texto": "Translate the following word: Olá",
        "tipo": "multipla",
        "answer": ["Hello", "Hi"],
    },
    {
        "id": 2,
        "titulo": "The Basics",
        "nivel_dificuldade": 0,
        "texto": "Translate the following word: Tchau",
        "tipo": "multipla",
        "answer": ["Bye", "Good bye"],
    },
    {
    "id": 3,
    "titulo": "Questão 1: Intermediário",
    "nivel_dificuldade": 2,
    "texto": "Qual é a tradução correta de house em português?",
    "tipo": "unica",
    "respostas": [
        { "id": 1, "resposta": "Casa", "correta": True },
        { "id": 2, "resposta": "Carro", "correta": False },
        { "id": 3, "resposta": "Cachorro", "correta": False },
        { "id": 4, "resposta": "Mesa", "correta": False }
    ]
    }
]

PROFESSORES_DB = [
    {
        "id": 1,
        "nome": "Mari B.", 
        "email": "a@example.com",
        "foto_url": "https://bestwayportuguese.com/wp-content/uploads/2024/08/WhatsApp-Image-2024-07-09-at-19.54.30-e1723810655108.jpg", 
        "telefone": "99999999",
        "linguas": "Native Portuguese | Fluent English",        
        "texto": "Hey! If you are looking for fun and interesting Portuguese classes with a passionate teacher, well, you just found them. I am Mariana, I am from Brasília, but now I live in Natal and I am really looking forward too helping you on this learning journey.", # Campo adicionado
        "link": "https://bestwayportuguese.com/teacher/mari-b/",
    },
    {
        "id": 2,
        "nome": "Pamela A", 
        "email": "a@example.com",
        "foto_url": "https://bestwayportuguese.com/wp-content/uploads/2024/04/Professora-Pamela-Andrade.jpg", 
        "telefone": "exemploo",
        "linguas": "Native Portuguese | Fluent English",         
        "texto": "Oi, tudo bem? :) My name is Pamela. I am from São Paulo, but now I live in China. I’m interested in languages, literature, music and history, that’s why I became a language teacher. Book a lesson and let’s start learning Portuguese.", # Campo adicionado
        "link": "https://bestwayportuguese.com/teacher/pamela-a/",
    }
]


'''
Nivel:
    {
    id: "1",
    titulo: "Iniciante",
    peso: "0.1",
    },
        {
    id: "2",
    titulo: "Intermediario",
    peso: "0.25",
    },
    
'''
