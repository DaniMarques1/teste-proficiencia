# Este arquivo serve como um "banco de dados" temporário em memória.
# No futuro, os dados virão do banco de dados real.

QUESTIONS_DB = [
    {
        "id": 1,
        "header": "The Basics",
        "level": 0,
        "texto": "Translate the following:",
        "questao": "Olá",
        "tipo": "texto",
        "answer": ["Hello", "Hi"],
    },
    {
        "id": 2,
        "header": "The Basics",
        "level": 0,
        "texto": "Translate the following:",
        "questao": "Tchau",
        "tipo": "texto",
        "answer": ["Bye", "Good bye"],
    },
    {
    "id": 3,
    "header": "Politeness",
    "level": 1,
    "texto": "Choose the right answer:",
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

PROFESSORES_DB = [
    {
        "id": 1,
        "name": "Mari B.", 
        "photo_url": "https://bestwayportuguese.com/wp-content/uploads/2024/08/WhatsApp-Image-2024-07-09-at-19.54.30-e1723810655108.jpg", 
        "native_langs": "Português (Brasil)",        
        "description": "Hey! If you are looking for fun and interesting Portuguese classes with a passionate teacher, well, you just found them. I am Mariana, I am from Brasília, but now I live in Natal and I am really looking forward too helping you on this learning journey.", # Campo adicionado
        "link": "https://bestwayportuguese.com/teacher/mari-b/",
    },
    {
        "id": 2,
        "name": "Pamela A", 
        "photo_url": "https://bestwayportuguese.com/wp-content/uploads/2024/04/Professora-Pamela-Andrade.jpg", 
        "native_langs": "Português (Brasil)",         
        "description": "Oi, tudo bem? :) My name is Pamela. I am from São Paulo, but now I live in China. I’m interested in languages, literature, music and history, that’s why I became a language teacher. Book a lesson and let’s start learning Portuguese.", # Campo adicionado
        "link": "https://bestwayportuguese.com/teacher/pamela-a/",
    }
]



