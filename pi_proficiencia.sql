-- =======================================
-- BANCO DE DADOS: pi_proficiencia
-- Estrutura + Questões de Proficiência
-- =======================================


-- ========================
-- CRIAÇÃO DO BANCO DE DADOS
-- ========================
CREATE DATABASE IF NOT EXISTS pi_proficiencia
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;
    
USE pi_proficiencia;


-- ========================
-- TABELA ADM - EXCLUÍDA PARA NÃO ENTRAR EM CONFLITO COM O DJANGO
-- ========================

-- ========================
-- TABELA PROFESSORES
-- ========================
CREATE TABLE IF NOT EXISTS professores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    foto_url VARCHAR(550),
    linguas VARCHAR(225),
    texto VARCHAR(4000),
    link VARCHAR(550),
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- TABELA USUARIOS
-- ========================
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    aceita_contato BOOLEAN DEFAULT FALSE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- TABELA QUESTOES
-- ========================
CREATE TABLE IF NOT EXISTS questoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    questao VARCHAR(10) NOT NULL,
    texto TEXT NOT NULL,
    tipo ENUM('unica','multipla','dissertativa') DEFAULT 'unica',
    nivel_dificuldade INT NOT NULL,
    explicacao VARCHAR(512),
    microfone BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT FALSE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ========================
-- TABELA RESPOSTAS
-- ========================
CREATE TABLE IF NOT EXISTS respostas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    questao_id INT NOT NULL,
    resposta TEXT NOT NULL,
    correta BOOLEAN DEFAULT FALSE,
    ordem INT,
    FOREIGN KEY (questao_id) REFERENCES questoes(id) ON DELETE CASCADE
);

-- ========================
-- TABELA NIVEIS_DIFICULDADE
-- ========================
CREATE TABLE IF NOT EXISTS niveis_dificuldade (
    id INT PRIMARY KEY,
    nivel VARCHAR(50) NOT NULL UNIQUE,
    peso DECIMAL(5, 2) NOT NULL
);


-- ====================
-- INSERTS DE EXEMPLO
-- ====================

INSERT INTO professores (nome, email, telefone, foto_url, linguas, texto, link) VALUES
('Mari B.', 
'a@example.com', 
'99999999',
'https://bestwayportuguese.com/wp-content/uploads/2024/08/WhatsApp-Image-2024-07-09-at-19.54.30-e1723810655108.jpg',
'Native Portuguese | Fluent English',
'Hey! If you are looking for fun and interesting Portuguese classes with a passionate teacher, well, you just found them. I am Mariana, I am from Brasília, but now I live in Natal and I am really looking forward too helping you on this learning journey.',
'https://bestwayportuguese.com/teacher/mari-b/');

INSERT INTO professores (nome, email, telefone, foto_url, linguas, texto, link) VALUES
('Pamela A', 
'a@example2.com', 
'9999999911',
'https://bestwayportuguese.com/wp-content/uploads/2024/04/Professora-Pamela-Andrade.jpg',
'Native Portuguese | Fluent English',
'Oi, tudo bem? :) My name is Pamela. I am from São Paulo, but now I live in China. I’m interested in languages, literature, music and history, that’s why I became a language teacher. Book a lesson and let’s start learning Portuguese.',
'https://bestwayportuguese.com/teacher/pamela-a/');

INSERT INTO usuarios (nome, email, aceita_contato) VALUES
('Maria Souza', 'maria@teste.com', TRUE);

INSERT INTO niveis_dificuldade (id, nivel, peso) VALUES
('1', 'Básico', '0.1');

INSERT INTO niveis_dificuldade (id, nivel, peso) VALUES
('2', 'Intermediário', '0.25');

INSERT INTO niveis_dificuldade (id, nivel, peso) VALUES
('3', 'Intermediário Superior', '0.4');

INSERT INTO niveis_dificuldade (id, nivel, peso) VALUES
('4', 'Avançado', '0.6');

INSERT INTO niveis_dificuldade (id, nivel, peso) VALUES
('5', 'Avançado Superior', '0.8');


-- ========================
-- QUESTÕES - INTERMEDIÁRIO (12)
-- ========================

-- Questão 1
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q1', 'Questão 1 - Intermediário', 'Qual é a tradução correta de "house" em português?', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Casa', TRUE, 1),
(LAST_INSERT_ID(), 'Carro', FALSE, 2),
(LAST_INSERT_ID(), 'Cachorro', FALSE, 3),
(LAST_INSERT_ID(), 'Mesa', FALSE, 4);

-- Questão 2
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q2', 'Questão 2 - Intermediário', 'Complete a frase: Eu ____ ao Brasil no ano passado.', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'foi', FALSE, 1),
(LAST_INSERT_ID(), 'fui', TRUE, 2),
(LAST_INSERT_ID(), 'vou', FALSE, 3),
(LAST_INSERT_ID(), 'iria', FALSE, 4);

-- Questão 3
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q3', 'Questão 3 - Intermediário', 'Qual das opções está no plural?', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Cadeira', FALSE, 1),
(LAST_INSERT_ID(), 'Mesa', FALSE, 2),
(LAST_INSERT_ID(), 'Livros', TRUE, 3),
(LAST_INSERT_ID(), 'Janela', FALSE, 4);

-- Questão 4
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q4', 'Questão 4 - Intermediário', 'Qual é a forma correta: "Eles ____ estudando português."', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'estão', TRUE, 1),
(LAST_INSERT_ID(), 'está', FALSE, 2),
(LAST_INSERT_ID(), 'estamos', FALSE, 3),
(LAST_INSERT_ID(), 'sou', FALSE, 4);

-- Questão 5
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q5', 'Questão 5 - Intermediário', 'Marque a alternativa que corresponde a um verbo:', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Correr', TRUE, 1),
(LAST_INSERT_ID(), 'Bonito', FALSE, 2),
(LAST_INSERT_ID(), 'Amarelo', FALSE, 3),
(LAST_INSERT_ID(), 'Rápido', FALSE, 4);

-- Questão 6
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q6', 'Questão 6 - Intermediário', 'Qual é o antônimo de "feliz"?', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Alegre', FALSE, 1),
(LAST_INSERT_ID(), 'Triste', TRUE, 2),
(LAST_INSERT_ID(), 'Contente', FALSE, 3),
(LAST_INSERT_ID(), 'Satisfeito', FALSE, 4);

-- Questão 7
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q7', 'Questão 7 - Intermediário', 'Qual das palavras abaixo é um substantivo?', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Correr', FALSE, 1),
(LAST_INSERT_ID(), 'Amor', TRUE, 2),
(LAST_INSERT_ID(), 'Bonito', FALSE, 3),
(LAST_INSERT_ID(), 'Rápido', FALSE, 4);

-- Questão 8
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q8', 'Questão 8 - Intermediário', 'Escolha a opção que está no futuro: "Amanhã eu ____ ao cinema."', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Fui', FALSE, 1),
(LAST_INSERT_ID(), 'Vou', TRUE, 2),
(LAST_INSERT_ID(), 'Ia', FALSE, 3),
(LAST_INSERT_ID(), 'Estava', FALSE, 4);

-- Questão 9
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q9', 'Questão 9 - Intermediário', 'Qual das frases está correta?', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Nós vai ao mercado.', FALSE, 1),
(LAST_INSERT_ID(), 'Nós vamos ao mercado.', TRUE, 2),
(LAST_INSERT_ID(), 'Eu vamos ao mercado.', FALSE, 3),
(LAST_INSERT_ID(), 'Eles vou ao mercado.', FALSE, 4);

-- Questão 10
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q10', 'Questão 10 - Intermediário', 'Qual é o feminino de "menino"?', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Menina', TRUE, 1),
(LAST_INSERT_ID(), 'Mulher', FALSE, 2),
(LAST_INSERT_ID(), 'Garoto', FALSE, 3),
(LAST_INSERT_ID(), 'Pessoa', FALSE, 4);

-- Questão 11
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q11', 'Questão 11 - Intermediário', 'Qual destas palavras é um adjetivo?', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Mesa', FALSE, 1),
(LAST_INSERT_ID(), 'Correr', FALSE, 2),
(LAST_INSERT_ID(), 'Bonito', TRUE, 3),
(LAST_INSERT_ID(), 'Amor', FALSE, 4);

-- Questão 12
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q12', 'Questão 12 - Intermediário', 'Escolha a frase no passado.', 'unica', 2, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Eu estudo todos os dias.', FALSE, 1),
(LAST_INSERT_ID(), 'Eu estudei ontem.', TRUE, 2),
(LAST_INSERT_ID(), 'Eu estudarei amanhã.', FALSE, 3),
(LAST_INSERT_ID(), 'Eu estudando agora.', FALSE, 4);


-- ========================
-- QUESTÕES - INTERMEDIÁRIO SUPERIOR (6)
-- ========================

-- Questão 13
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q13', 'Leia o texto: "Maria estuda português todos os dias. Ela gosta muito da língua e quer viajar ao Brasil no próximo ano." Pergunta: O que Maria estuda todos os dias?', 'unica', 3, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Inglês', FALSE, 1),
(LAST_INSERT_ID(), 'Português', TRUE, 2),
(LAST_INSERT_ID(), 'Espanhol', FALSE, 3),
(LAST_INSERT_ID(), 'Francês', FALSE, 4);

-- Questão 14
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q14', 'Leia o texto: "João trabalha em uma empresa de tecnologia. Ele gosta de programar e sempre aprende coisas novas." Pergunta: Em que área João trabalha?', 'unica', 3, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Educação', FALSE, 1),
(LAST_INSERT_ID(), 'Saúde', FALSE, 2),
(LAST_INSERT_ID(), 'Tecnologia', TRUE, 3),
(LAST_INSERT_ID(), 'Agricultura', FALSE, 4);

-- Questão 15
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q15', 'Leia o texto: "Ontem Ana foi ao mercado e comprou frutas, legumes e pães frescos." Pergunta: O que Ana comprou no mercado?', 'unica', 3, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Roupas', FALSE, 1),
(LAST_INSERT_ID(), 'Eletrodomésticos', FALSE, 2),
(LAST_INSERT_ID(), 'Frutas, legumes e pães', TRUE, 3),
(LAST_INSERT_ID(), 'Ferramentas', FALSE, 4);

-- Questão 16
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q16', 'Leia o texto: "Pedro gosta de esportes. Ele joga futebol nos finais de semana com seus amigos." Pergunta: Qual esporte Pedro pratica?', 'unica', 3, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Basquete', FALSE, 1),
(LAST_INSERT_ID(), 'Vôlei', FALSE, 2),
(LAST_INSERT_ID(), 'Futebol', TRUE, 3),
(LAST_INSERT_ID(), 'Natação', FALSE, 4);

-- Questão 17
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q17', 'Leia o texto: "Carla gosta de música. Ela toca violão e canta muito bem." Pergunta: Qual instrumento Carla toca?', 'unica', 3, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Piano', FALSE, 1),
(LAST_INSERT_ID(), 'Violão', TRUE, 2),
(LAST_INSERT_ID(), 'Bateria', FALSE, 3),
(LAST_INSERT_ID(), 'Flauta', FALSE, 4);

-- Questão 18
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q18', 'Leia o texto: "Os alunos participaram de uma feira de ciências, onde apresentaram experimentos e aprenderam com as pesquisas dos colegas." Pergunta: O que os alunos fizeram na feira de ciências?', 'unica', 3, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Assistiram a um filme', FALSE, 1),
(LAST_INSERT_ID(), 'Apresentaram experimentos', TRUE, 2),
(LAST_INSERT_ID(), 'Foram ao teatro', FALSE, 3),
(LAST_INSERT_ID(), 'Jogaram futebol', FALSE, 4);


-- ========================
-- QUESTÕES - AVANÇADO (12)
-- ========================

-- Questão 19
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q19', 'Leia o texto: "Durante sua viagem ao Brasil, Mark percebeu que aprender português exigia dedicação diária, prática constante e contato com nativos." Pergunta: O que Mark percebeu sobre aprender português?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Que era fácil', FALSE, 1),
(LAST_INSERT_ID(), 'Que exigia dedicação diária', TRUE, 2),
(LAST_INSERT_ID(), 'Que não precisava praticar', FALSE, 3),
(LAST_INSERT_ID(), 'Que era impossível', FALSE, 4);

-- Questão 20
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q20', 'Leia o texto: "Os estudantes estrangeiros participaram de um intercâmbio cultural, onde puderam compartilhar experiências, aprender expressões idiomáticas e conhecer a culinária local." Pergunta: O que os estudantes aprenderam durante o intercâmbio?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Somente gramática', FALSE, 1),
(LAST_INSERT_ID(), 'Somente geografia', FALSE, 2),
(LAST_INSERT_ID(), 'Expressões idiomáticas e culinária local', TRUE, 3),
(LAST_INSERT_ID(), 'Somente matemática', FALSE, 4);

-- Questão 21
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q21', 'Leia o texto: "Apesar das dificuldades iniciais, Julia conseguiu se adaptar ao novo ambiente acadêmico, desenvolvendo não apenas sua fluência em português, mas também sua autoconfiança." Pergunta: Além da fluência em português, o que Julia desenvolveu?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Autoconfiança', TRUE, 1),
(LAST_INSERT_ID(), 'Timidez', FALSE, 2),
(LAST_INSERT_ID(), 'Medo de falar', FALSE, 3),
(LAST_INSERT_ID(), 'Desinteresse', FALSE, 4);

-- Questão 22
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q22', 'Leia o texto: "No seminário internacional, os palestrantes destacaram a importância da preservação da Amazônia e do papel do Brasil nas discussões ambientais globais." Pergunta: Qual foi o tema destacado no seminário?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Tecnologia', FALSE, 1),
(LAST_INSERT_ID(), 'Preservação da Amazônia', TRUE, 2),
(LAST_INSERT_ID(), 'Esportes', FALSE, 3),
(LAST_INSERT_ID(), 'Economia mundial', FALSE, 4);

-- Questão 23
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q23', 'Leia o texto: "Com o aumento das interações comerciais, muitos executivos estrangeiros precisam aprender português para negociar contratos, participar de reuniões e compreender documentos oficiais." Pergunta: Por que os executivos precisam aprender português?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Para viajar a lazer', FALSE, 1),
(LAST_INSERT_ID(), 'Para negociar contratos e participar de reuniões', TRUE, 2),
(LAST_INSERT_ID(), 'Para aprender apenas cultura', FALSE, 3),
(LAST_INSERT_ID(), 'Para evitar aprender inglês', FALSE, 4);

-- Questão 24
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q24', 'Leia o texto: "Os imigrantes enfrentaram dificuldades de comunicação, mas, com o tempo, aprenderam o português e conseguiram boas oportunidades de trabalho." Pergunta: O que os imigrantes conseguiram após aprender português?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Viajar', FALSE, 1),
(LAST_INSERT_ID(), 'Boas oportunidades de trabalho', TRUE, 2),
(LAST_INSERT_ID(), 'Aprender inglês', FALSE, 3),
(LAST_INSERT_ID(), 'Comprar casas', FALSE, 4);

-- Questão 25
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q25', 'Leia o texto: "Os turistas estrangeiros relataram que a hospitalidade brasileira foi um dos pontos mais marcantes de sua viagem." Pergunta: O que os turistas destacaram?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Comida brasileira', FALSE, 1),
(LAST_INSERT_ID(), 'Hospitalidade brasileira', TRUE, 2),
(LAST_INSERT_ID(), 'Transporte público', FALSE, 3),
(LAST_INSERT_ID(), 'Clima do Brasil', FALSE, 4);

-- Questão 26
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q26', 'Leia o texto: "Muitos estudantes utilizam aplicativos de tradução para auxiliar no aprendizado do português, mas reconhecem que conversar com nativos é mais eficiente." Pergunta: O que os estudantes consideram mais eficiente?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Ler gramáticas', FALSE, 1),
(LAST_INSERT_ID(), 'Conversar com nativos', TRUE, 2),
(LAST_INSERT_ID(), 'Usar aplicativos', FALSE, 3),
(LAST_INSERT_ID(), 'Fazer provas', FALSE, 4);

-- Questão 27
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q27', 'Leia o texto: "Nas universidades brasileiras, os alunos estrangeiros têm acesso a cursos de língua portuguesa e atividades culturais para melhorar sua integração." Pergunta: O que é oferecido aos alunos estrangeiros?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Somente cursos de inglês', FALSE, 1),
(LAST_INSERT_ID(), 'Cursos de português e atividades culturais', TRUE, 2),
(LAST_INSERT_ID(), 'Somente alimentação gratuita', FALSE, 3),
(LAST_INSERT_ID(), 'Cursos de música', FALSE, 4);

-- Questão 28
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q28', 'Leia o texto: "As empresas brasileiras valorizam profissionais que dominam o português, principalmente em cargos de atendimento ao público." Pergunta: Que tipo de profissionais são valorizados?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Que dominam inglês', FALSE, 1),
(LAST_INSERT_ID(), 'Que dominam português', TRUE, 2),
(LAST_INSERT_ID(), 'Que sabem matemática', FALSE, 3),
(LAST_INSERT_ID(), 'Que falam espanhol', FALSE, 4);

-- Questão 29
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q29', 'Leia o texto: "O governo promove campanhas para incentivar estrangeiros a aprenderem português como forma de integração social." Pergunta: Qual é o objetivo das campanhas?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Ensinar inglês', FALSE, 1),
(LAST_INSERT_ID(), 'Integração social', TRUE, 2),
(LAST_INSERT_ID(), 'Promover esportes', FALSE, 3),
(LAST_INSERT_ID(), 'Turismo', FALSE, 4);

-- Questão 30
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q30', 'Leia o texto: "Os pesquisadores analisaram como a literatura brasileira contribui para a aprendizagem da língua, especialmente através da leitura de clássicos." Pergunta: O que os pesquisadores analisaram?', 'unica', 4, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A culinária brasileira', FALSE, 1),
(LAST_INSERT_ID(), 'A literatura brasileira e sua contribuição', TRUE, 2),
(LAST_INSERT_ID(), 'A música popular brasileira', FALSE, 3),
(LAST_INSERT_ID(), 'O cinema brasileiro', FALSE, 4);


-- ========================
-- QUESTÕES - AVANÇADO SUPERIOR (10)
-- ========================

-- Questão 31
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q31', 'Leia o texto: "A globalização intensificou as relações econômicas e culturais entre países, tornando o domínio de diferentes idiomas, incluindo o português, uma ferramenta estratégica." Pergunta: Por que o domínio do português é considerado estratégico?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Porque facilita apenas o turismo', FALSE, 1),
(LAST_INSERT_ID(), 'Porque fortalece relações econômicas e culturais', TRUE, 2),
(LAST_INSERT_ID(), 'Porque substitui o inglês', FALSE, 3),
(LAST_INSERT_ID(), 'Porque é obrigatório em toda a Europa', FALSE, 4);

-- Questão 32
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q32', 'Leia o texto: "Ao analisar o impacto da mídia digital, os pesquisadores identificaram que os estrangeiros utilizam podcasts e vídeos em português para acelerar seu aprendizado." Pergunta: Que recursos digitais os estrangeiros utilizam para aprender português?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Apenas livros', FALSE, 1),
(LAST_INSERT_ID(), 'Podcasts e vídeos', TRUE, 2),
(LAST_INSERT_ID(), 'Somente jogos', FALSE, 3),
(LAST_INSERT_ID(), 'Revistas impressas', FALSE, 4);

-- Questão 33
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q33', 'Leia o texto: "Durante o congresso, foi ressaltada a relevância da língua portuguesa como idioma oficial em organismos internacionais, como a CPLP e a União Africana." Pergunta: Onde a língua portuguesa foi destacada como oficial?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Na ONU e na OTAN', FALSE, 1),
(LAST_INSERT_ID(), 'Na CPLP e União Africana', TRUE, 2),
(LAST_INSERT_ID(), 'Na União Europeia', FALSE, 3),
(LAST_INSERT_ID(), 'Na OMC', FALSE, 4);

-- Questão 34
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q34', 'Leia o texto: "As universidades brasileiras oferecem programas de pós-graduação em que a proficiência em português é requisito fundamental para participação em atividades acadêmicas avançadas." Pergunta: Qual é o requisito fundamental para os programas de pós-graduação?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Proficiência em português', TRUE, 1),
(LAST_INSERT_ID(), 'Somente saber inglês', FALSE, 2),
(LAST_INSERT_ID(), 'Conhecimento em matemática', FALSE, 3),
(LAST_INSERT_ID(), 'Experiência em turismo', FALSE, 4);

-- Questão 35
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q35', 'Leia o texto: "A literatura contemporânea em português tem despertado o interesse de leitores estrangeiros, que buscam compreender não apenas a língua, mas também os contextos sociais retratados." Pergunta: O que os leitores estrangeiros buscam compreender?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Somente a gramática', FALSE, 1),
(LAST_INSERT_ID(), 'A língua e os contextos sociais', TRUE, 2),
(LAST_INSERT_ID(), 'Apenas a cultura europeia', FALSE, 3),
(LAST_INSERT_ID(), 'Somente traduções automáticas', FALSE, 4);

-- Questão 36
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q36', 'Leia o texto: "Com o avanço da diplomacia brasileira, a fluência em português tornou-se um diferencial competitivo para profissionais de relações internacionais." Pergunta: Em qual área a fluência em português se tornou um diferencial?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Relações internacionais', TRUE, 1),
(LAST_INSERT_ID(), 'Engenharia civil', FALSE, 2),
(LAST_INSERT_ID(), 'Artes plásticas', FALSE, 3),
(LAST_INSERT_ID(), 'Educação infantil', FALSE, 4);

-- Questão 37
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q37', 'Leia o texto: "Pesquisas acadêmicas têm apontado que a imersão cultural, como morar em países lusófonos, acelera significativamente o aprendizado do português." Pergunta: O que acelera o aprendizado do português segundo as pesquisas?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Apenas aulas online', FALSE, 1),
(LAST_INSERT_ID(), 'Imersão cultural', TRUE, 2),
(LAST_INSERT_ID(), 'Tradução automática', FALSE, 3),
(LAST_INSERT_ID(), 'Estudar sozinho sem prática', FALSE, 4);

-- Questão 38
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q38', 'Leia o texto: "A diversidade linguística no Brasil, marcada por sotaques e expressões regionais, representa um desafio adicional para estrangeiros em fase de aprendizagem." Pergunta: O que representa desafio adicional para estrangeiros?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Sotaques e expressões regionais', TRUE, 1),
(LAST_INSERT_ID(), 'Apenas a gramática formal', FALSE, 2),
(LAST_INSERT_ID(), 'Traduções literais', FALSE, 3),
(LAST_INSERT_ID(), 'A tecnologia', FALSE, 4);

-- Questão 39
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q39', 'Leia o texto: "A integração entre países de língua portuguesa tem ampliado o mercado editorial, permitindo a circulação de obras e autores em diferentes continentes." Pergunta: O que foi ampliado com a integração dos países lusófonos?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Mercado editorial', TRUE, 1),
(LAST_INSERT_ID(), 'Apenas exportação agrícola', FALSE, 2),
(LAST_INSERT_ID(), 'Tecnologia bélica', FALSE, 3),
(LAST_INSERT_ID(), 'Esportes olímpicos', FALSE, 4);

-- Questão 40
INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('Q40', 'Leia o texto: "Estudos recentes demonstram que a aprendizagem do português por estrangeiros pode fortalecer laços diplomáticos e econômicos entre países." Pergunta: Quais laços podem ser fortalecidos com a aprendizagem do português?', 'unica', 5, FALSE, 'teste');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Diplomáticos e econômicos', TRUE, 1),
(LAST_INSERT_ID(), 'Somente esportivos', FALSE, 2),
(LAST_INSERT_ID(), 'Somente familiares', FALSE, 3),
(LAST_INSERT_ID(), 'Somente turísticos', FALSE, 4);
