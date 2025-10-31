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
    microfone BOOLEAN DEFAULT TRUE,
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
    peso DECIMAL(5, 2) NOT NULL,
    maximo_questoes INT NOT NULL DEFAULT 1
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
('Mari B.', 'mari.b@example.com', '99999999', 'https://bestwayportuguese.com/wp-content/uploads/2024/08/WhatsApp-Image-2024-07-09-at-19.54.30-e1723810655108.jpg', 'Native Portuguese | Fluent English', 'Hey! If you are looking for fun and interesting Portuguese classes with a passionate teacher, well, you just found them. I am Mariana, I am from Brasília, but now I live in Natal and I am really looking forward too helping you on this learning journey.', 'https://bestwayportuguese.com/teacher/mari-b/'),
('Pamela A.', 'pamela.a@example.com', '9999999911', 'https://bestwayportuguese.com/wp-content/uploads/2024/04/Professora-Pamela-Andrade.jpg', 'Native Portuguese | Fluent English', 'Oi, tudo bem?:) My name is Pamela. I am from São Paulo, but now I live in China. I\'m interested in languages, literature, music and history, that\'s why I became a language teacher. Book a lesson and let\'s start learning Portuguese.', 'https://bestwayportuguese.com/teacher/pamela-a/'),
('João P.', 'joao.p@example.com', '9999999912', 'https://bestwayportuguese.com/wp-content/uploads/2023/07/Teacher-Joao-Pedro.png', 'Native Portuguese | Fluent English | Spanish', 'Hi, guys. I\'m João Paulo and you may know me from the Portuguese tips from "Tudo Bom?" on social media. But if you don\'t, hurry up and book a lesson with me. We\'re gonna have a good conversation and learn more about the Brazilian language.', 'https://bestwayportuguese.com/teacher/joao-p/'),
('Andressa M.', 'andressa.m@example.com', '9999999913', 'https://bestwayportuguese.com/wp-content/uploads/2023/03/me.jpg', 'Native Portuguese | Fluent English', 'Hey there, it\'s Andressa here! You might know me from Falando Nisso com Andressa on YouTube, but in case you don\'t, why not booking a lesson and let me help you learn Brazilian Portuguese with a charming Rio de Janeiro accent?', 'https://bestwayportuguese.com/teacher/andressa-m/'),
('Haroldo M.', 'haroldo.m@example.com', '9999999914', 'https://bestwayportuguese.com/wp-content/uploads/2023/03/perfil-Haroldo-bestwayportuguese.jpg', 'Native Portuguese | Fluent English | French | Italian', 'Hello! I\'m Haroldo, a musician with a passion for languages, travel and cultures around the world. What about we start learning Portuguese together?', 'https://bestwayportuguese.com/teacher/haroldo/'),
('Dahare D.', 'dahare.d@example.com', '9999999915', 'https://bestwayportuguese.com/wp-content/uploads/2023/01/0c117fcc-dbe6-42f7-9f16-601cbf308fcc.jpg', 'Native Portuguese | Fluent English | French | Spanish', 'As a learner of French and Spanish I know that learning a language isn\'t the easiest thing to do, but it\'s easier when you have an experienced teacher like me! Book a lesson and let\'s start your path to fluency!', 'https://bestwayportuguese.com/teacher/dahare-d/'),
('Vlad S.', 'vlad.s@example.com', '9999999916', 'https://bestwayportuguese.com/wp-content/uploads/2022/10/foto-vlad.jpg', 'Native Portuguese | Catalan | Fluent English | French | Italian | Spanish', 'Hey, there! I\'m Vlad, a polyglot, language learning enthusiast and modern nomad at heart, but now settled in São Paulo. Book a lesson now and let\'s take your learning to the next level!', 'https://bestwayportuguese.com/teacher/vlad-souza/');

INSERT INTO usuarios (nome, email, aceita_contato) VALUES
('Maria Souza', 'maria@teste.com', TRUE);

INSERT INTO niveis_dificuldade (id, nivel, peso, maximo_questoes) VALUES
(1, 'Fácil', -1.0, 1),
(2, 'Médio', 0.0, 1),
(3, 'Difícil', 1.0, 1);

-- ========================
-- QUESTÕES 
-- ========================

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI001', 'Embora a expansão do metrô seja frequentemente celebrada como símbolo de progresso urbano, em muitas capitais as novas linhas priorizam áreas centrais, enquanto bairros periféricos continuam sem acesso eficiente ao transporte. O que o texto critica sobre a expansão do metrô em grandes cidades?', 'unica', 3, FALSE, 'Correta — o texto evidencia a concentração de investimentos no centro urbano, ampliando desigualdades.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto elogia a distribuição equilibrada das linhas de metrô.', FALSE, 1),
(LAST_INSERT_ID(), 'O texto critica o fato de que a expansão beneficia desproporcionalmente as regiões centrais.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto destaca que o metrô é o meio de transporte mais barato para as periferias.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto considera o metrô o principal fator de inclusão digital.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI002', 'O texto reconhece a importância econômica do agronegócio, mas aponta que o avanço sobre áreas de vegetação nativa compromete a imagem internacional do país e ameaça recursos hídricos estratégicos. O que o autor questiona sobre a expansão do agronegócio brasileiro?', 'unica', 3, FALSE, 'Correta — o texto alerta para impactos ambientais e de imagem.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O autor enxerga a expansão do agronegócio como totalmente positiva.', FALSE, 1),
(LAST_INSERT_ID(), 'A expansão agrícola traz riscos ambientais e de reputação internacional ao país.', TRUE, 2),
(LAST_INSERT_ID(), 'O autor propõe eliminar totalmente a produção agrícola.', FALSE, 3),
(LAST_INSERT_ID(), 'O problema principal é a queda de produtividade do setor.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI003', 'A proliferação de informações falsas nas redes sociais tem potencial para manipular o comportamento dos eleitores, distorcendo o debate público e enfraquecendo a confiança nas instituições democráticas. Qual é o principal risco que o texto associa à disseminação de fake news durante eleições?', 'unica', 3, FALSE, 'Correta — o texto relaciona desinformação a enfraquecimento institucional.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'As fake news fortalecem o debate democrático ao ampliar opiniões divergentes.', FALSE, 1),
(LAST_INSERT_ID(), 'A manipulação da opinião pública ameaça a integridade do processo democrático.', TRUE, 2),
(LAST_INSERT_ID(), 'O problema principal é o aumento da arrecadação das plataformas digitais.', FALSE, 3),
(LAST_INSERT_ID(), 'As fake news têm pouco impacto sobre o comportamento político.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI004', 'O contingenciamento de verbas afeta a continuidade de projetos de longo prazo, reduz a capacidade de inovação e torna o país mais dependente de tecnologia estrangeira. O que o texto sugere sobre os cortes no orçamento de pesquisa científica?', 'unica', 3, FALSE, 'Correta — o texto mostra efeitos de longo prazo sobre inovação e dependência externa.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Os cortes não têm impacto sobre a inovação nacional.', FALSE, 1),
(LAST_INSERT_ID(), 'Os cortes comprometem a continuidade e a autonomia científica do país.', TRUE, 2),
(LAST_INSERT_ID(), 'O problema central é o aumento de impostos sobre universidades privadas.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto defende o fim da pesquisa científica no país.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI005', 'O crescimento econômico tem sido frequentemente associado ao aumento das emissões de carbono. Especialistas apontam, porém, que políticas de incentivo à energia limpa podem permitir desenvolvimento sem degradação ambiental. O que o texto sugere sobre a relação entre crescimento econômico e sustentabilidade ambiental?', 'unica', 3, FALSE, 'Correta — o texto indica que desenvolvimento e sustentabilidade podem coexistir com políticas adequadas.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O crescimento econômico sempre causa danos ambientais irreversíveis.', FALSE, 1),
(LAST_INSERT_ID(), 'Políticas de incentivo à energia limpa podem permitir crescimento econômico sustentável.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto defende a substituição completa da economia por fontes renováveis.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que energia limpa é inviável economicamente.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI006', 'A inclusão da educação financeira nas escolas visa formar cidadãos mais conscientes sobre o uso do dinheiro. No entanto, especialistas alertam que, sem capacitação dos professores, o conteúdo pode ser superficial e ineficaz. Qual é o argumento principal do texto sobre a inclusão da educação financeira no currículo escolar?', 'unica', 3, FALSE, 'Correta — o texto afirma que sem capacitação docente o aprendizado é comprometido.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A educação financeira é desnecessária para o público jovem.', FALSE, 1),
(LAST_INSERT_ID(), 'A eficácia da educação financeira depende da formação adequada dos professores.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto propõe eliminar o tema do currículo.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto defende substituir a educação financeira por matemática aplicada.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI007', 'A publicação de dados orçamentários é fundamental para o controle social. Entretanto, se as informações forem divulgadas de forma técnica e pouco acessível, a participação popular fica limitada. O que o texto indica sobre o papel da transparência nos governos democráticos?', 'unica', 3, FALSE, 'Correta — o texto enfatiza que não basta publicar dados, é preciso torná-los compreensíveis.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A transparência sempre garante participação cidadã ampla.', FALSE, 1),
(LAST_INSERT_ID(), 'A qualidade e clareza das informações são essenciais para uma transparência efetiva.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto critica a divulgação de dados financeiros pelo governo.', FALSE, 3),
(LAST_INSERT_ID(), 'O problema está na falta de dados sobre segurança pública.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI008', 'As políticas de cotas ampliaram o acesso de grupos historicamente excluídos às universidades. No entanto, a permanência estudantil ainda depende de apoio financeiro e estrutura adequada. O que o texto sugere sobre as políticas de inclusão no ensino superior?', 'unica', 3, FALSE, 'Correta — o texto enfatiza que inclusão real envolve acesso e manutenção.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto defende que apenas o acesso inicial é suficiente para garantir igualdade educacional.', FALSE, 1),
(LAST_INSERT_ID(), 'O texto destaca que ampliar o acesso é importante, mas é preciso garantir condições de permanência.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto afirma que as políticas de cotas são desnecessárias.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto discute apenas a qualidade dos cursos oferecidos.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI009', 'A adoção de algoritmos em decisões públicas exige transparência e supervisão humana, pois erros podem afetar diretamente direitos e oportunidades de cidadãos. O que o texto aponta sobre o uso ético da inteligência artificial?', 'unica', 3, FALSE, 'Correta — o texto ressalta a importância da supervisão para evitar injustiças automatizadas.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto indica que o uso ético da IA depende de transparência e controle humano.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que os algoritmos substituem com segurança todas as decisões humanas.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto defende o uso irrestrito de sistemas automatizados.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto trata apenas de benefícios econômicos da IA.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI010', 'O planejamento urbano sustentável requer equilíbrio entre expansão econômica e preservação ambiental, priorizando transporte público e áreas verdes. O que o texto indica sobre o planejamento das cidades sustentáveis?', 'unica', 3, FALSE, 'Correta — o texto destaca que o desenvolvimento sustentável deve conciliar economia e ecologia.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto defende o equilíbrio entre crescimento urbano e proteção ambiental.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que o desenvolvimento urbano deve ignorar a natureza.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto diz que apenas o setor privado deve cuidar da sustentabilidade.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto aborda apenas o aumento de construções.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI011', 'Com o aumento do tempo online, muitos usuários compartilham informações pessoais sem perceber os riscos à privacidade e à segurança de dados. O que o texto sugere sobre o comportamento dos usuários nas redes digitais?', 'unica', 3, FALSE, 'Correta — o texto relaciona o compartilhamento excessivo à vulnerabilidade digital.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto alerta sobre os perigos de expor informações pessoais na internet.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que publicar dados pessoais é sempre seguro.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto recomenda compartilhar dados para melhorar a comunicação.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto trata apenas de entretenimento nas redes sociais.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI012', 'A disseminação de notícias falsas enfraquece o debate público e compromete a confiança nas instituições democráticas. O que o texto indica sobre os riscos da desinformação?', 'unica', 3, FALSE, 'Correta — o texto relaciona a circulação de fake news à perda de credibilidade institucional.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto mostra que a desinformação ameaça o funcionamento da democracia.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que as fake news fortalecem o debate político.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto defende a criação de mais fake news como forma de expressão.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto trata apenas de publicidade e marketing digital.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AI013', 'Embora as ações individuais sejam importantes, o combate às mudanças climáticas depende de políticas públicas e compromissos internacionais coordenados. O que o texto sugere sobre a responsabilidade no enfrentamento das mudanças climáticas?', 'unica', 3, FALSE, 'Correta — o texto ressalta a necessidade de políticas e cooperação global.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto afirma que as ações individuais, sozinhas, não são suficientes para enfrentar a crise climática.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto diz que pequenas ações domésticas resolvem todos os problemas ambientais.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto defende que governos não têm papel na crise climática.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto trata apenas da economia global.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AS002', 'O governo anunciou metas ambiciosas para reduzir as emissões de carbono em 40% até 2035. No entanto, a proposta não inclui mecanismos de fiscalização ou penalidades para empresas que descumprirem as metas, o que tem gerado críticas entre ambientalistas. O que o texto indica sobre o desafio real de implementação do plano de redução de emissões?', 'unica', 3, FALSE, 'Correta — o texto sugere que o problema central é a ausência de fiscalização e penalidades, o que ameaça a implementação real.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'As metas são claras e contam com ampla fiscalização.', FALSE, 1),
(LAST_INSERT_ID(), 'O maior desafio é garantir a execução efetiva das metas sem instrumentos de controle.', TRUE, 2),
(LAST_INSERT_ID(), 'O principal desafio é reduzir o custo dos combustíveis fósseis.', FALSE, 3),
(LAST_INSERT_ID(), 'A resistência dos consumidores ao transporte público inviabiliza as metas.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AS003', 'A reforma tributária unifica impostos sobre consumo e promete simplificar o sistema. Economistas alertam, porém, que a alíquota única pode tornar o sistema mais regressivo, pois famílias de baixa renda destinam maior parte do orçamento ao consumo. O que o texto sugere sobre o impacto distributivo da nova reforma tributária?', 'unica', 3, FALSE, 'Correta — o texto aponta que o peso do imposto será proporcionalmente maior sobre as famílias de menor renda.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A reforma torna o sistema mais progressivo, beneficiando as famílias pobres.', FALSE, 1),
(LAST_INSERT_ID(), 'A alíquota única pode ampliar a desigualdade de renda, afetando mais os pobres.', TRUE, 2),
(LAST_INSERT_ID(), 'A reforma eliminará completamente a carga tributária sobre o consumo.', FALSE, 3),
(LAST_INSERT_ID(), 'O impacto da reforma será neutro em todas as faixas de renda.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AS004', 'O governo lançou um programa que distribui tablets para estudantes de comunidades rurais. Contudo, muitas dessas regiões não possuem acesso confiável à internet ou eletricidade estável, comprometendo o uso dos equipamentos. Qual é a principal limitação estrutural da política de inclusão digital descrita no texto?', 'unica', 3, FALSE, 'Correta — o texto aponta a ausência de conectividade e energia como o obstáculo central à eficácia do programa.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A falta de treinamento dos professores impede o uso dos tablets.', FALSE, 1),
(LAST_INSERT_ID(), 'A infraestrutura precária de internet e energia inviabiliza o uso efetivo dos dispositivos.', TRUE, 2),
(LAST_INSERT_ID(), 'O desinteresse dos alunos pela tecnologia limita o aprendizado.', FALSE, 3),
(LAST_INSERT_ID(), 'O excesso de tecnologia nas escolas causa distrações.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AS005', 'O crescimento acelerado da energia solar reduziu a dependência de combustíveis fósseis, mas também gerou aumento no descarte de painéis antigos sem destinação adequada, levantando preocupações ambientais. O que o texto evidencia sobre os efeitos colaterais da rápida expansão da energia solar no país?', 'unica', 3, FALSE, 'Correta — o texto evidencia um trade-off: redução de emissões, mas aumento no lixo tecnológico.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A energia solar não tem impactos ambientais significativos.', FALSE, 1),
(LAST_INSERT_ID(), 'O avanço tecnológico trouxe benefícios e desafios ambientais simultaneamente.', TRUE, 2),
(LAST_INSERT_ID(), 'O uso de energia solar elimina completamente a necessidade de reciclagem.', FALSE, 3),
(LAST_INSERT_ID(), 'O descarte de painéis é irrelevante diante dos benefícios da energia solar.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AS006', 'O governo ampliou subsídios para grandes produtores rurais a fim de estimular exportações. Entretanto, pequenos agricultores afirmam que a medida concentra ainda mais renda e crédito nas mãos dos maiores produtores. O que o texto sugere sobre as consequências socioeconômicas dos subsídios agrícolas?', 'unica', 3, FALSE, 'Correta — o texto indica que os benefícios econômicos estão sendo distribuídos de forma desigual, ampliando a concentração de renda rural.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Os subsídios beneficiam igualmente pequenos e grandes agricultores.', FALSE, 1),
(LAST_INSERT_ID(), 'A política agrava a desigualdade no campo, favorecendo grandes produtores.', TRUE, 2),
(LAST_INSERT_ID(), 'A política reduz a concentração de crédito ao apoiar pequenos produtores.', FALSE, 3),
(LAST_INSERT_ID(), 'Os subsídios priorizam a agricultura familiar para estimular o consumo interno.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AS007', 'O governo anunciou subsídios para construções em áreas periféricas, visando reduzir o déficit habitacional. No entanto, especialistas alertam que a ausência de infraestrutura básica nesses locais — como transporte, escolas e saneamento — pode transformar o benefício em isolamento urbano. O que o texto sugere sobre o impacto real das novas políticas habitacionais?', 'unica', 3, FALSE, 'Correta — o texto indica que a ausência de infraestrutura ameaça o resultado positivo da política.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A expansão habitacional resolverá integralmente o déficit urbano.', FALSE, 1),
(LAST_INSERT_ID(), 'O principal desafio é garantir infraestrutura adequada nas novas áreas habitadas.', TRUE, 2),
(LAST_INSERT_ID(), 'As novas moradias estão localizadas em regiões centrais bem atendidas.', FALSE, 3),
(LAST_INSERT_ID(), 'O problema principal é o custo excessivo das construções.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AS008', 'Estudos indicam que a automação pode aumentar a produtividade global. Entretanto, sem políticas de requalificação, há o risco de ampliar a desigualdade entre trabalhadores qualificados e os que perderão espaço no mercado. O que o autor destaca como risco social associado ao avanço da inteligência artificial?', 'unica', 3, FALSE, 'Correta — o texto associa ausência de requalificação à ampliação da desigualdade.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A automação gera desemprego apenas temporário.', FALSE, 1),
(LAST_INSERT_ID(), 'O risco principal é ampliar desigualdades entre diferentes perfis de trabalhadores.', TRUE, 2),
(LAST_INSERT_ID(), 'O autor defende a substituição total da mão de obra humana.', FALSE, 3),
(LAST_INSERT_ID(), 'O problema central é a redução da produtividade.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('AS009', 'Os testes nacionais buscam medir o desempenho escolar, mas acabam induzindo o ensino voltado apenas às provas. Assim, habilidades como criatividade e pensamento crítico tendem a ser negligenciadas. Que crítica o texto faz às avaliações padronizadas nas escolas públicas?', 'unica', 3, FALSE, 'Correta — o texto critica o efeito de estreitamento curricular.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Os testes padronizados fortalecem o desenvolvimento criativo dos alunos.', FALSE, 1),
(LAST_INSERT_ID(), 'O foco exclusivo nas provas pode reduzir o estímulo a outras habilidades cognitivas.', TRUE, 2),
(LAST_INSERT_ID(), 'A principal falha é a ausência de provas em disciplinas exatas.', FALSE, 3),
(LAST_INSERT_ID(), 'O autor sugere eliminar completamente as avaliações nacionais.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B001', 'Os cães são animais de estimação que precisam de atenção, carinho e passeios diários para se manterem saudáveis e felizes. O que o texto diz sobre os cães?', 'unica', 1, FALSE, 'Correta — o texto afirma claramente que os cães precisam de cuidado e caminhadas.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Os cães precisam de atenção e passeios diários.', TRUE, 1),
(LAST_INSERT_ID(), 'Os cães vivem bem sem sair de casa.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre alimentação dos peixes.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto fala sobre vacinação de gatos.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B002', 'As frutas são fontes naturais de vitaminas e ajudam a fortalecer o sistema imunológico. O que o texto afirma sobre as frutas?', 'unica', 1, FALSE, 'Correta — o texto afirma explicitamente que as frutas ajudam o sistema imunológico.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'As frutas contêm vitaminas que fortalecem o corpo.', TRUE, 1),
(LAST_INSERT_ID(), 'As frutas prejudicam a saúde.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre legumes e verduras.', FALSE, 3),
(LAST_INSERT_ID(), 'As frutas não contêm nutrientes importantes.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B003', 'O transporte público ajuda a reduzir o trânsito e a poluição nas cidades. O que o texto informa sobre o transporte público?', 'unica', 1, FALSE, 'Correta — o texto afirma que o transporte público reduz esses problemas.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O transporte público contribui para diminuir o trânsito e a poluição.', TRUE, 1),
(LAST_INSERT_ID(), 'O transporte público aumenta o número de carros nas ruas.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto trata de transporte aéreo.', FALSE, 3),
(LAST_INSERT_ID(), 'O transporte público causa mais poluição.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B004', 'Estudar um pouco todos os dias ajuda na memorização e melhora o aprendizado. O que o texto afirma sobre o hábito de estudar?', 'unica', 1, FALSE, 'Correta — o texto afirma explicitamente esse benefício.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Estudar diariamente melhora a memorização.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto diz que estudar pouco não ajuda.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre atividade física.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto recomenda estudar apenas antes das provas.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B005', 'Lavar as mãos antes das refeições e após usar o banheiro evita o contágio de doenças. O que o texto ensina sobre a higiene?', 'unica', 1, FALSE, 'Correta — o texto diz isso diretamente.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Lavar as mãos ajuda a evitar doenças.', TRUE, 1),
(LAST_INSERT_ID(), 'Lavar as mãos causa doenças.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre escovação de dentes.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto diz que não há necessidade de lavar as mãos.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B006', 'Apagar as luzes ao sair de um cômodo e desligar aparelhos que não estão sendo usados ajudam a reduzir o consumo de energia elétrica. O que o texto recomenda para economizar energia?', 'unica', 1, FALSE, 'Correta — o texto indica essas ações como formas de economizar energia.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Apagar as luzes e desligar aparelhos economiza energia.', TRUE, 1),
(LAST_INSERT_ID(), 'Deixar as luzes acesas o tempo todo.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre economia de água.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto sugere usar mais aparelhos eletrônicos.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B007', 'As crianças precisam de refeições equilibradas, com frutas, verduras e proteínas, para crescerem fortes e saudáveis. O que o texto diz sobre a alimentação das crianças?', 'unica', 1, FALSE, 'Correta — o texto afirma que a alimentação equilibrada é essencial para o crescimento.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'As crianças devem ter uma alimentação equilibrada para crescerem saudáveis.', TRUE, 1),
(LAST_INSERT_ID(), 'As crianças não precisam comer frutas e verduras.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre alimentação de adultos.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto diz que as crianças devem evitar refeições saudáveis.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B008', 'A amizade é construída com respeito, confiança e tempo. Bons amigos se apoiam e celebram as conquistas uns dos outros. O que o texto afirma sobre a amizade?', 'unica', 1, FALSE, 'Correta — o texto cita explicitamente respeito e confiança como base da amizade.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A amizade é baseada em respeito e confiança.', TRUE, 1),
(LAST_INSERT_ID(), 'A amizade depende apenas de dinheiro.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto diz que amigos verdadeiros não se ajudam.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto fala sobre colegas de trabalho.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B009', 'As estações do ano — primavera, verão, outono e inverno — acontecem por causa da posição da Terra em relação ao Sol. O que o texto explica sobre as estações do ano?', 'unica', 1, FALSE, 'Correta — o texto afirma isso de forma direta.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'As estações acontecem por causa da posição da Terra em relação ao Sol.', TRUE, 1),
(LAST_INSERT_ID(), 'As estações são causadas pelas fases da Lua.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre os dias da semana.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto diz que o clima é igual o ano todo.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('B010', 'Respeitar colegas e professores ajuda a manter um ambiente escolar harmonioso e produtivo para todos. O que o texto ensina sobre o convívio escolar?', 'unica', 1, FALSE, 'Correta — o texto afirma que o respeito mantém o ambiente harmonioso.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O respeito é importante para um bom convívio na escola.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto incentiva desrespeitar colegas.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre esportes escolares.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que o respeito atrapalha o aprendizado.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('BI001', 'Maria comeu pão e tomou café com leite no café da manhã. O que o texto diz que a Maria comeu no café da manhã?', 'unica', 1, FALSE, 'Correta — o texto afirma exatamente isso.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Maria comeu pão e tomou café com leite.', TRUE, 1),
(LAST_INSERT_ID(), 'Maria comeu frutas e suco.', FALSE, 2),
(LAST_INSERT_ID(), 'Maria não comeu nada.', FALSE, 3),
(LAST_INSERT_ID(), 'Maria comeu arroz e feijão.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('BI002', 'O gato dorme no sofá todas as tardes. O que o texto fala sobre o gato?', 'unica', 1, FALSE, 'Correta — é a informação literal do texto.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O gato dorme no sofá todas as tardes.', TRUE, 1),
(LAST_INSERT_ID(), 'O gato corre no quintal.', FALSE, 2),
(LAST_INSERT_ID(), 'O gato dorme de manhã.', FALSE, 3),
(LAST_INSERT_ID(), 'O gato dorme na cama.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('BI003', 'Os alunos estão escrevendo no caderno. O que o texto diz que os alunos estão fazendo?', 'unica', 1, FALSE, 'Correta — o texto afirma isso literalmente.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Os alunos estão escrevendo no caderno.', TRUE, 1),
(LAST_INSERT_ID(), 'Os alunos estão brincando no pátio.', FALSE, 2),
(LAST_INSERT_ID(), 'Os alunos estão lendo um livro.', FALSE, 3),
(LAST_INSERT_ID(), 'Os alunos estão dormindo na sala.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('BI004', 'O cachorro correu atrás da bola no quintal. O que o texto conta sobre o cachorro?', 'unica', 1, FALSE, 'Correta — o texto afirma exatamente isso.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O cachorro correu atrás da bola no quintal.', TRUE, 1),
(LAST_INSERT_ID(), 'O cachorro dormiu na varanda.', FALSE, 2),
(LAST_INSERT_ID(), 'O cachorro comeu ração.', FALSE, 3),
(LAST_INSERT_ID(), 'O cachorro brincou com outro gato.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('BI005', 'Está chovendo e as crianças estão em casa vendo televisão. O que o texto diz sobre o tempo?', 'unica', 1, FALSE, 'Correta — o texto descreve exatamente isso.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Está chovendo e as crianças estão em casa.', TRUE, 1),
(LAST_INSERT_ID(), 'Está fazendo sol e as crianças estão no parque.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre praia e verão.', FALSE, 3),
(LAST_INSERT_ID(), 'As crianças estão brincando na rua.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II001', 'Comprar apenas o que é necessário e evitar desperdícios são atitudes que reduzem o impacto ambiental e ajudam a preservar os recursos naturais. Qual é a mensagem principal do texto sobre o consumo responsável?', 'unica', 2, FALSE, 'Correta — o texto relaciona o consumo responsável à redução de impactos ambientais.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto incentiva o consumo exagerado como forma de movimentar a economia.', FALSE, 1),
(LAST_INSERT_ID(), 'O consumo consciente contribui para a preservação do meio ambiente.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto sugere que o desperdício é benéfico para o planeta.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que o consumo não afeta o meio ambiente.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II002', 'O trabalho voluntário fortalece o senso de solidariedade e ajuda a resolver problemas que o poder público nem sempre consegue atender. O que o texto mostra sobre o papel do voluntariado na sociedade?', 'unica', 2, FALSE, 'Correta — o texto destaca a importância do voluntariado como complemento às políticas públicas.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O voluntariado é uma atividade sem impacto social relevante.', FALSE, 1),
(LAST_INSERT_ID(), 'O trabalho voluntário complementa ações do governo e promove solidariedade.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto afirma que o voluntariado substitui completamente o governo.', FALSE, 3),
(LAST_INSERT_ID(), 'O voluntariado é motivado apenas por recompensas financeiras.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II003', 'A prática de exercícios melhora a disposição, fortalece o sistema imunológico e reduz o risco de várias doenças. O que o texto afirma sobre a prática regular de atividades físicas?', 'unica', 2, FALSE, 'Correta — o texto relaciona a prática regular à melhora da saúde física e mental.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Os exercícios aumentam o risco de doenças.', FALSE, 1),
(LAST_INSERT_ID(), 'Os exercícios contribuem para a saúde e o bem-estar geral.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto recomenda evitar exercícios por motivos de segurança.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que o exercício tem apenas efeitos estéticos.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II004', 'A educação ambiental busca conscientizar as pessoas sobre a importância de conservar o meio ambiente e adotar hábitos sustentáveis no dia a dia. Qual é o principal objetivo da educação ambiental, segundo o texto?', 'unica', 2, FALSE, 'Correta — o texto associa educação ambiental à formação de atitudes ecológicas no cotidiano.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Ensinar apenas conceitos teóricos de biologia.', FALSE, 1),
(LAST_INSERT_ID(), 'Estimular comportamentos responsáveis e sustentáveis.', TRUE, 2),
(LAST_INSERT_ID(), 'Criticar a atuação das escolas públicas.', FALSE, 3),
(LAST_INSERT_ID(), 'Promover o consumo de produtos industrializados.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II005', 'Atravessar na faixa e respeitar o semáforo são atitudes simples que previnem acidentes e tornam o trânsito mais seguro para todos. O que o texto ensina sobre o comportamento dos pedestres?', 'unica', 2, FALSE, 'Correta — o texto relaciona diretamente comportamento responsável e segurança no trânsito.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Os pedestres não precisam respeitar o semáforo.', FALSE, 1),
(LAST_INSERT_ID(), 'Cumprir as regras de travessia ajuda a evitar acidentes.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto incentiva os pedestres a atravessar fora da faixa para economizar tempo.', FALSE, 3),
(LAST_INSERT_ID(), 'A segurança no trânsito depende apenas dos motoristas.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II006', 'Ter uma dieta equilibrada, com frutas, verduras e alimentos frescos, é essencial para manter o corpo saudável e prevenir doenças. Qual é o principal conselho do texto sobre alimentação?', 'unica', 2, FALSE, 'Correta — o texto associa dieta saudável à manutenção da saúde e prevenção de doenças.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto recomenda o consumo frequente de alimentos industrializados.', FALSE, 1),
(LAST_INSERT_ID(), 'O texto sugere que a alimentação equilibrada ajuda na prevenção de doenças.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto critica o consumo de frutas e verduras.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que a alimentação não influencia na saúde.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II007', 'Reciclar reduz a quantidade de lixo nos aterros e permite reaproveitar materiais, diminuindo o consumo de recursos naturais. O que o texto explica sobre a importância da reciclagem?', 'unica', 2, FALSE, 'Correta — o texto associa reciclagem à redução de lixo e uso consciente dos recursos.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A reciclagem aumenta o volume de lixo produzido.', FALSE, 1),
(LAST_INSERT_ID(), 'Reciclar ajuda a economizar recursos e diminuir a poluição.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto critica a prática da reciclagem como ineficiente.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que reciclar é proibido em áreas urbanas.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II008', 'Os avanços tecnológicos facilitaram tarefas do dia a dia, mas também aumentaram o tempo que as pessoas passam em frente às telas. O que o texto diz sobre o papel da tecnologia na vida moderna?', 'unica', 2, FALSE, 'Correta — o texto reconhece benefícios e efeitos negativos da tecnologia.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A tecnologia não trouxe mudanças significativas na rotina das pessoas.', FALSE, 1),
(LAST_INSERT_ID(), 'A tecnologia tornou a vida mais prática, mas também mais dependente de telas.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto defende o abandono completo da tecnologia.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que as pessoas passaram a usar menos dispositivos eletrônicos.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II009', 'Fechar a torneira enquanto escova os dentes e consertar vazamentos são formas simples de economizar água e evitar o desperdício. O que o texto ensina sobre o uso da água?', 'unica', 2, FALSE, 'Correta — o texto mostra que ações simples reduzem o desperdício de água.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto incentiva o desperdício de água.', FALSE, 1),
(LAST_INSERT_ID(), 'Pequenas atitudes ajudam a economizar água e proteger o meio ambiente.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto recomenda deixar a torneira aberta o tempo todo.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto defende o uso ilimitado de recursos naturais.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II010', 'A diversidade cultural enriquece a sociedade ao permitir que diferentes tradições e modos de vida convivam e se respeitem mutuamente. Qual é a ideia principal do texto sobre a diversidade cultural?', 'unica', 2, FALSE, 'Correta — o texto relaciona diversidade à riqueza e harmonia social.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A diversidade cultural prejudica a convivência social.', FALSE, 1),
(LAST_INSERT_ID(), 'O respeito às diferenças culturais fortalece a convivência social.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto defende a uniformização dos costumes.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que a convivência entre culturas é impossível.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II011', 'Trabalhar em grupo permite compartilhar ideias e encontrar soluções melhores, pois cada pessoa contribui com uma habilidade diferente. O que o texto destaca sobre o trabalho em equipe?', 'unica', 2, FALSE, 'Correta — o texto afirma que a troca de ideias e habilidades melhora os resultados.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Trabalhar em equipe ajuda a combinar diferentes habilidades para resolver problemas.', TRUE, 1),
(LAST_INSERT_ID(), 'Trabalhar em grupo é sempre mais difícil e menos produtivo.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto defende que as pessoas devem trabalhar sozinhas.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto diz que o trabalho em grupo atrapalha o aprendizado.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II012', 'Comer frutas, verduras e evitar o excesso de alimentos industrializados melhora o funcionamento do corpo e previne doenças. O que o texto explica sobre a alimentação saudável?', 'unica', 2, FALSE, 'Correta — o texto indica que hábitos alimentares saudáveis previnem doenças.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Uma alimentação equilibrada ajuda a manter o corpo saudável.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto recomenda o consumo de alimentos industrializados.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto diz que frutas e verduras prejudicam a saúde.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que a alimentação não interfere na saúde.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II013', 'Ler todos os dias amplia o vocabulário, estimula o raciocínio e ajuda na compreensão de novos assuntos. Qual é a ideia central do texto sobre o hábito da leitura?', 'unica', 2, FALSE, 'Correta — o texto mostra que ler fortalece a aprendizagem e o raciocínio.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A leitura diária contribui para o desenvolvimento do conhecimento e da linguagem.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que a leitura é uma perda de tempo.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala apenas sobre leitura de receitas.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que ler é necessário apenas na escola.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II014', 'Separar o lixo e reaproveitar materiais como papel e plástico ajuda a reduzir a poluição e preservar o meio ambiente. O que o texto ensina sobre a reciclagem?', 'unica', 2, FALSE, 'Correta — o texto explica que a separação e o reaproveitamento de materiais beneficiam o meio ambiente.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A reciclagem ajuda a diminuir a poluição e economizar recursos naturais.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto diz que reciclar aumenta a poluição.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto defende jogar o lixo em qualquer lugar.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto fala apenas sobre coleta de esgoto.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('II015', 'Praticar atividades físicas regularmente melhora o humor, fortalece os músculos e previne doenças. O que o texto diz sobre os exercícios físicos?', 'unica', 2, FALSE, 'Correta — o texto afirma que o exercício fortalece o corpo e melhora o bem-estar.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Os exercícios físicos fazem bem à saúde e ajudam na prevenção de doenças.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que o exercício causa doenças.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala sobre alimentação saudável.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto recomenda evitar qualquer tipo de atividade física.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS001', 'Apesar das campanhas de conscientização, muitos consumidores continuam priorizando a praticidade das embalagens plásticas, mesmo conhecendo seus impactos ambientais. O que o texto sugere sobre o comportamento do consumidor em relação ao uso de plástico?', 'unica', 2, FALSE, 'Correta — o texto mostra que o conforto e a praticidade influenciam mais que a consciência ecológica.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Os consumidores reduziram drasticamente o uso de plástico após as campanhas.', FALSE, 1),
(LAST_INSERT_ID(), 'A conveniência ainda prevalece sobre a preocupação ambiental nas escolhas do consumidor.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto afirma que o consumidor desconhece os impactos do plástico.', FALSE, 3),
(LAST_INSERT_ID(), 'As campanhas eliminaram o uso de embalagens plásticas nas grandes cidades.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS002', 'Após a adoção de rótulos frontais de advertência, aumentou a atenção dos consumidores para produtos com excesso de açúcar, mas o impacto nas vendas ainda é incerto. Qual é o efeito das políticas de rotulagem nutricional descritas no texto?', 'unica', 2, FALSE, 'Correta — o texto indica maior atenção do público, mas incerteza quanto às vendas.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A medida reduziu comprovadamente as vendas de alimentos ultraprocessados.', FALSE, 1),
(LAST_INSERT_ID(), 'Os rótulos aumentaram a conscientização, embora os resultados econômicos ainda sejam indefinidos.', TRUE, 2),
(LAST_INSERT_ID(), 'A medida eliminou totalmente o consumo de produtos açucarados.', FALSE, 3),
(LAST_INSERT_ID(), 'Os rótulos confundiram os consumidores em relação ao conteúdo dos alimentos.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS003', 'Pesquisas mostram que o trabalho remoto aumentou a produtividade individual em diversas áreas, mas também trouxe desafios de comunicação e integração entre equipes. O que o texto afirma sobre os efeitos do trabalho remoto nas empresas?', 'unica', 2, FALSE, 'Correta — o texto reconhece aumento de produtividade, mas ressalta problemas de integração.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O trabalho remoto reduziu a produtividade em todos os setores.', FALSE, 1),
(LAST_INSERT_ID(), 'O trabalho remoto combina ganhos de produtividade com dificuldades de interação social.', TRUE, 2),
(LAST_INSERT_ID(), 'O texto afirma que o trabalho remoto foi abandonado em todo o país.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto defende o retorno obrigatório ao modelo presencial.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS004', 'Apesar da ampla oferta de vacinas, parte da população ainda resiste à imunização, influenciada por informações falsas disseminadas nas redes sociais. Qual é o principal problema abordado pelo texto?', 'unica', 2, FALSE, 'Correta — o texto estabelece relação direta entre fake news e hesitação vacinal.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A resistência às vacinas está ligada à desinformação nas redes sociais.', TRUE, 1),
(LAST_INSERT_ID(), 'A população tem aderido integralmente às campanhas de vacinação.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto defende o fim das campanhas de vacinação.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto explica que a desinformação reduziu o número de vacinas disponíveis.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS011', 'A instalação de parques eólicos tem impulsionado a economia local com novos empregos, mas moradores relatam aumento do ruído e alterações na paisagem natural. O que o texto sugere sobre o impacto da energia eólica nas comunidades próximas?', 'unica', 2, FALSE, 'Correta — o texto aponta efeitos positivos e negativos, destacando um equilíbrio de impactos.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto mostra que a energia eólica traz benefícios econômicos e também desafios ambientais e sociais.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que a energia eólica não causa nenhum impacto nas comunidades.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto defende o encerramento dos projetos eólicos.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto trata apenas dos impactos visuais das turbinas.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS012', 'Inserir temas de educação financeira nas aulas ajuda os jovens a planejar gastos e compreender o valor do dinheiro, promovendo decisões mais conscientes no futuro. O que o texto indica sobre o ensino de finanças pessoais nas escolas?', 'unica', 2, FALSE, 'Correta — o texto mostra que o ensino financeiro favorece autonomia e consciência econômica.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto defende que ensinar finanças pessoais estimula decisões responsáveis e planejamento financeiro.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que o ensino de finanças é desnecessário na escola.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto diz que os jovens já têm total domínio sobre finanças.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto fala apenas sobre matemática aplicada.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS013', 'O uso crescente de robôs e sistemas inteligentes tem aumentado a produtividade, mas exige requalificação profissional para evitar o desemprego. O que o texto sugere sobre o avanço da automação nas empresas?', 'unica', 2, FALSE, 'Correta — o texto mostra a dualidade entre eficiência e necessidade de capacitação.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'A automação traz ganhos de produtividade, mas também demanda adaptação dos trabalhadores.', TRUE, 1),
(LAST_INSERT_ID(), 'A automação elimina todos os empregos humanos.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto diz que os robôs pioram o desempenho das empresas.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto defende o fim do uso de tecnologia no ambiente de trabalho.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS014', 'Muitos usuários leem apenas manchetes ou conteúdos parciais, o que pode levar à formação de opiniões sem compreensão completa dos fatos. O que o texto aponta sobre o hábito de leitura de notícias nas redes sociais?', 'unica', 2, FALSE, 'Correta — o texto relaciona leitura superficial a desinformação e julgamentos apressados.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto alerta para os riscos de formar opiniões baseadas em informações incompletas.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que todos os usuários leem notícias com atenção.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto recomenda que as pessoas deixem de ler qualquer notícia online.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto elogia o comportamento dos leitores que comentam sem ler.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS015', 'Uma cidade inteligente utiliza tecnologia para melhorar a mobilidade, reduzir o consumo de energia e tornar os serviços públicos mais eficientes. O que o texto indica sobre o conceito de cidade inteligente?', 'unica', 2, FALSE, 'Correta — o texto define o conceito como aplicação tecnológica para melhoria da gestão urbana.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'Uma cidade inteligente busca eficiência urbana por meio do uso de tecnologia.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que cidade inteligente é aquela que tem muitos prédios altos.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto diz que cidade inteligente é aquela com população pequena.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto fala apenas sobre transporte público.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS016', 'Estudos apontam que o aumento da temperatura média do planeta intensifica eventos climáticos extremos, como secas e enchentes, exigindo ações urgentes de mitigação. O que o texto sugere sobre o aumento das temperaturas globais?', 'unica', 2, FALSE, 'Correta — o texto conecta o aumento da temperatura à intensificação de eventos extremos.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto indica que o aquecimento global está relacionado ao aumento de fenômenos climáticos extremos.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que o clima mundial está se tornando mais estável.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto diz que as mudanças climáticas não causam impacto ambiental.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto trata apenas da economia global.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS017', 'A expansão do acesso à internet melhorou a comunicação, mas ainda há desigualdade no uso de tecnologias entre áreas urbanas e rurais. O que o texto aponta como desafio para a inclusão digital?', 'unica', 2, FALSE, 'Correta — o texto identifica a diferença entre áreas urbanas e rurais como o principal obstáculo.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto destaca que a desigualdade no acesso à internet dificulta a plena inclusão digital.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que todos têm acesso igual à internet.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto diz que a tecnologia já resolveu todos os problemas sociais.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto fala apenas sobre redes sociais.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS018', 'O modelo híbrido combina dias presenciais e remotos, proporcionando mais flexibilidade, mas exigindo disciplina para manter a produtividade. O que o texto indica sobre o modelo de trabalho híbrido?', 'unica', 2, FALSE, 'Correta — o texto destaca os benefícios e os desafios do modelo simultaneamente.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto mostra que o trabalho híbrido oferece flexibilidade, mas exige responsabilidade individual.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto afirma que o trabalho híbrido elimina a necessidade de organização.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto recomenda abolir o trabalho remoto.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que o modelo híbrido reduz o desempenho profissional.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS019', 'O consumo responsável de água envolve atitudes simples, como fechar a torneira enquanto se escova os dentes e consertar vazamentos. O que o texto ensina sobre o uso racional da água?', 'unica', 2, FALSE, 'Correta — o texto associa atitudes cotidianas à preservação dos recursos hídricos.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto destaca que pequenas ações diárias ajudam a economizar água.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto incentiva o desperdício de água nas atividades domésticas.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala apenas sobre tratamento de esgoto.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que a economia de água depende apenas do governo.', FALSE, 4);

INSERT INTO questoes (questao, texto, tipo, nivel_dificuldade, microfone, explicacao) VALUES
('IS020', 'Proteger senhas e evitar compartilhar dados pessoais em sites desconhecidos são atitudes essenciais para manter a segurança digital. O que o texto indica sobre os cuidados com informações pessoais online?', 'unica', 2, FALSE, 'Correta — o texto relaciona boas práticas digitais à proteção de dados.');
INSERT INTO respostas (questao_id, resposta, correta, ordem) VALUES
(LAST_INSERT_ID(), 'O texto explica que hábitos seguros na internet ajudam a proteger informações pessoais.', TRUE, 1),
(LAST_INSERT_ID(), 'O texto incentiva o compartilhamento de senhas.', FALSE, 2),
(LAST_INSERT_ID(), 'O texto fala apenas sobre redes sociais.', FALSE, 3),
(LAST_INSERT_ID(), 'O texto afirma que a segurança digital é desnecessária.', FALSE, 4);

