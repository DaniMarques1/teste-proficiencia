import { fetchQuestion, fetchTeachers, checkAnswerAPI } from './api.js';
import { renderQuestionUI, displayFeedbackScreen, displayQuizFinished, applyFade } from './ui.js';
import { initializeAudioFeatures } from './audio.js';

// --- ESTADO GLOBAL DO QUIZ ---
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

// --- ELEMENTOS DA TELA DE APRESENTAÇÃO ---
const presentationContainer = document.getElementById('presentation-container');
const startQuizButton = document.getElementById('start-quiz-button');

// --- FUNÇÕES DE CONTROLE DO QUIZ ---
async function loadQuestion() {
    try {
        const data = await fetchQuestion(currentQuestionId);
        currentQuestionData = data;
        
        questionTitleElement.textContent = `${data.titulo}`;
        renderQuestionUI(data, cardsContainer);
        initializeAudioFeatures();
        
        const textInput = document.getElementById('translation-input');
        if (textInput) {
            textInput.addEventListener('keyup', handleEnterKey);
        }
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
        const teachers = await fetchTeachers();

        setTimeout(() => {
            quizContainer.style.display = 'none';
            feedbackContainer.style.display = 'block';
            
            displayFeedbackScreen(resultados, teachers, questionTitleElement, feedbackContainer);
            
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
        console.error("Erro ao buscar professores:", error);
        questionTitleElement.textContent = 'Erro ao carregar resultados';
        feedbackContainer.innerHTML = `<p>Não foi possível carregar as recomendações. Tente novamente mais tarde.</p>`;
        feedbackContainer.style.display = 'block';
    }
}

async function checkAnswer() {
    if (!currentQuestionData) return;

    let userAnswer = 'No answer';
    let userAnswerId = null;

    // Pega a resposta selecionada pelo usuário
    const selectedOption = document.querySelector('.answer-option.selected');

    if (selectedOption) {
        userAnswer = selectedOption.textContent;
        userAnswerId = parseInt(selectedOption.dataset.id);
    }

    try {
        // Chama a API para verificar a resposta no backend
        const result = await checkAnswerAPI(currentQuestionData.id, userAnswerId);

        // Adiciona o resultado ao array de resultados
        resultados.push({
            question: currentQuestionData.titulo, // ou .texto
            userAnswer,
            correctAnswer: result.correct_answer,
            isCorrect: result.is_correct
        });

        // Só então carrega a próxima questão
        loadNextQuestion();

    } catch (error) {
        console.error('Error checking answer:', error);
        alert('Não foi possível verificar sua resposta. Tente novamente.');
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
userDataForm.addEventListener('submit', (event) => {
    event.preventDefault();
    applyFade(userDataContainer, 'out');
    setTimeout(() => {
        userDataContainer.style.display = 'none';
        presentationContainer.style.display = 'block';
        requestAnimationFrame(() => applyFade(presentationContainer, 'in'));
    }, 300);
});

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