import { fetchQuestion, fetchTeachers, checkAnswerAPI } from './api.js';
import { renderQuestionUI, displayFeedbackScreen, displayQuizFinished, applyFade } from './ui.js';
import { initializeAudioFeatures } from './audio.js';

// --- ESTADO GLOBAL DO QUIZ ---
let questionNumber = 1;
let currentQuestionData = null;
let currentQuestionId = 1;
let resultados = [];

// --- ELEMENTOS PRINCIPAIS DO DOM ---
const userDataContainer = document.getElementById('user-data-container');
const userDataForm = document.getElementById('user-data-form');
const quizContainer = document.querySelector('.quiz-container');
const feedbackContainer = document.getElementById('feedback-container');
const questionTitleElement = document.getElementById('question-title');
const cardsContainer = document.getElementById('cards-container');
const nextButton = document.getElementById('next-button');
const skipAuthButton = document.querySelector('.skip-auth-button');

// --- ELEMENTOS DA TELA DE APRESENTAÇÃO ---
const presentationContainer = document.getElementById('presentation-container');
const startQuizButton = document.getElementById('start-quiz-button');

// --- FUNÇÕES DE CONTROLE DO QUIZ ---
async function loadQuestion() {
    try {
        const data = await fetchQuestion(currentQuestionId);
        currentQuestionData = data;
        
        // --- Linha modificada ---
        questionTitleElement.textContent = `Questão ${questionNumber}`; 
        
        renderQuestionUI(data, cardsContainer);
        initializeAudioFeatures();
        
        const textInput = document.getElementById('translation-input');
        if (textInput) {
            textInput.addEventListener('keyup', handleEnterKey);
        }

        // Incrementa o número para a próxima questão
        questionNumber++;

    } catch (error) {
        if (error.status === 404) {
            handleQuizEnd();
        } else {
            console.error('Error loading question:', error);
            questionTitleElement.textContent = 'Error loading question';
        }
    }
}

async function handleQuizEnd() {
    applyFade(quizContainer, 'out');
    nextButton.style.display = 'none';

    try {
        // 1️⃣ Primeiro envia resultados para o backend (gera relatório e recebe pontos fortes/fracos)
        const reportData = await sendResultsToBackend(); // <- chamada principal

        // 2️⃣ Depois busca professores normalmente
        const teachers = await fetchTeachers();

        // 3️⃣ Exibe o feedback com base nas respostas do backend
        setTimeout(() => {
            quizContainer.style.display = 'none';
            feedbackContainer.style.display = 'block';

            // Renderiza o feedback com os dados da IA (pontos fortes e fracos)
            displayFeedbackScreen(
                resultados,
                teachers,
                questionTitleElement,
                feedbackContainer,
                reportData?.pontos_fortes || [],
                reportData?.pontos_a_desenvolver || []
            );

            requestAnimationFrame(() => applyFade(feedbackContainer, 'in'));

            const emailButton = document.getElementById('get-results-button');
            const showDetailsButton = document.getElementById('show-details-button');

            if (emailButton) {
                emailButton.addEventListener('click', () => {
                    alert('Funcionalidade de envio de email a ser implementada!');
                });
            }

            if (showDetailsButton) {
                showDetailsButton.addEventListener('click', () => {
                    applyFade(feedbackContainer, 'out');
                    setTimeout(() => {
                        displayQuizFinished(resultados, questionTitleElement, feedbackContainer);
                        requestAnimationFrame(() => applyFade(feedbackContainer, 'in'));
                    }, 300);
                });
            }

        }, 300);

    } catch (error) {
        console.error("Erro ao finalizar quiz:", error);
        questionTitleElement.textContent = 'Erro ao carregar resultados';
        feedbackContainer.innerHTML = `<p>Não foi possível carregar as recomendações. Tente novamente mais tarde.</p>`;
        feedbackContainer.style.display = 'block';
    }
}


async function checkAnswer() {
    if (!currentQuestionData) return;

    const selectedOption = document.querySelector('.answer-option.selected');

    if (currentQuestionData.tipo === 'unica' && !selectedOption) {
        alert('Please, choose an answer.');
        return; 
    }

    let userAnswerId;
    let userAnswerText;

    if (currentQuestionData.tipo === 'unica') {
        userAnswerId = parseInt(selectedOption.dataset.id);
        userAnswerText = selectedOption.textContent;
    } else {
        console.log("Tipo de pergunta não suportado pela verificação de backend ainda.");
        return;
    }

    try {
        const csrftoken = getCookie('csrftoken'); 

        const result = await checkAnswerAPI(currentQuestionId, userAnswerId, csrftoken);

        resultados.push({
            question: currentQuestionData.texto,
            userAnswer: userAnswerText,
            correctAnswer: result.correct_answer_text, 
            isCorrect: result.is_correct,
            explicacao: result.explicacao
        });

        loadNextQuestion();

    } catch (error) {
        console.error('Erro ao verificar a resposta:', error);
        alert('Não foi possível verificar sua resposta. Tente novamente.');
    }
}

async function sendResultsToBackend() {
    const csrftoken = getCookie('csrftoken');

    const respostas = resultados.map(r => 
        `Question: ${r.question} | Your answer: ${r.userAnswer} | Correct answer: ${r.correctAnswer}`
    );

    const payload = {
        nome_aluno: "Rafael Souza",
        respostas: respostas,
        nivel: "A1 Intermediário",
        nota_final: 30,
        pdf: false
    };

    try {
        const response = await fetch("/gerar-relatorio/", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRFToken": csrftoken
            },
            body: JSON.stringify(payload)
        });

        const data = await response.json();

        if (response.ok) {
            console.log("✅ Relatório gerado com sucesso:", data);
            return data; // <-- RETORNA O JSON (pontos fortes e fracos)
        } else {
            alert("Erro ao gerar feedback: " + data.erro);
            return null;
        }
    } catch (error) {
        console.error("Erro ao enviar resultados:", error);
        return null;
    }
}


function loadNextQuestion() {
    applyFade(cardsContainer, 'out');

    setTimeout(() => {
        currentQuestionId++;
        loadQuestion().then(() => {
            applyFade(cardsContainer, 'in');
        });
    }, 300);
}

function handleEnterKey(event) {
    if (event.key === 'Enter') {
        event.preventDefault();
        nextButton.click();
    }
}

// --- INICIALIZAÇÃO E EVENTOS ---

nextButton.addEventListener('click', checkAnswer);

// Evento do formulário de dados do usuário
const csrftoken = getCookie('csrftoken'); // Pega o token na inicialização

userDataForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const formData = new FormData(userDataForm);

    document.querySelectorAll('.error-message').forEach(el => el.remove());

    fetch('/api/salvar-usuario/', {
        method: 'POST',
        body: formData,
        headers: {
            'X-CSRFToken': csrftoken 
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {

            applyFade(userDataContainer, 'out');
            
            setTimeout(() => {
                userDataContainer.style.display = 'none';
                const quizContainer = document.getElementById('presentation-container'); 
                
                if (quizContainer) {
                    quizContainer.style.display = 'block';
                    requestAnimationFrame(() => applyFade(quizContainer, 'in'));
                } else {
                    console.error('Erro: O container do quiz não foi encontrado!');
                }

                iniciarQuiz(); 

            }, 300); 


        } else if (data.status === 'error') {
            let errorMessages = [];
            for (const field in data.errors) {
                const errorList = data.errors[field];
                if (errorList.length > 0) {
                    const message = errorList[0].message; 
                    errorMessages.push(`- ${field}: ${message}`);
                }
            }
            if (errorMessages.length > 0) {
                alert(errorMessages.join('\n'));
            }
        }
    })
    .catch(error => {
        console.error('Erro na requisição:', error);
        alert('Ocorreu um erro de comunicação com o servidor.');
    });
});

skipAuthButton.addEventListener('click', (event) => {
    // Prevent the default button action (like form submission)
    event.preventDefault();

    // Get the container for the user data form
    const userDataContainer = document.getElementById('user-data-container');

    // Apply fade-out effect to the form container
    applyFade(userDataContainer, 'out');
    
    // After the fade-out animation (300ms), switch the containers
    setTimeout(() => {
        // Hide the form container
        userDataContainer.style.display = 'none';
        
        // Find the quiz container (assuming its ID is 'presentation-container' as in your original code)
        const quizContainer = document.getElementById('presentation-container'); 
        
        if (quizContainer) {
            // Show the quiz container and fade it in
            quizContainer.style.display = 'block';
            requestAnimationFrame(() => applyFade(quizContainer, 'in'));
        } else {
            console.error('Error: The quiz container was not found!');
        }

        // Start the quiz
        iniciarQuiz(); 

    }, 300); // This delay should match your fade-out transition time
});

function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

// Evento do botão 'Start Quiz' da tela de apresentação
startQuizButton.addEventListener('click', () => {
    applyFade(presentationContainer, 'out');
    setTimeout(() => {
        presentationContainer.style.display = 'none';
        quizContainer.style.display = 'block';
        requestAnimationFrame(() => applyFade(quizContainer, 'in'));
        loadQuestion();
    }, 300);
});