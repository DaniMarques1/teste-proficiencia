import { fetchQuestion } from './api.js';
import { renderQuestionUI, displayQuizFinished, applyFade } from './ui.js';
import { initializeAudioFeatures } from './audio.js';

// --- ESTADO GLOBAL DO QUIZ ---
let currentQuestionData = null;
let currentQuestionId = 1;
let resultados = [];

// --- ELEMENTOS PRINCIPAIS DO DOM ---
const userDataContainer = document.getElementById('user-data-container');
const userDataForm = document.getElementById('user-data-form');
const quizContainer = document.querySelector('.quiz-container');
const questionTitleElement = document.getElementById('question-title');
const cardsContainer = document.getElementById('cards-container');
const nextButton = document.getElementById('next-button');

// --- FUNÇÕES DE CONTROLE DO QUIZ ---
async function loadQuestion() {
    try {
        const data = await fetchQuestion(currentQuestionId);
        currentQuestionData = data;
        
        questionTitleElement.textContent = `Questão ${data.id}: ${data.header}`;
        renderQuestionUI(data, cardsContainer);
        initializeAudioFeatures();
        
        const textInput = document.getElementById('translation-input');
        if (textInput) {
            textInput.addEventListener('keyup', handleEnterKey);
        }
    } catch (error) {
        if (error.status === 404) {
            displayQuizFinished(resultados, questionTitleElement, cardsContainer);
            nextButton.style.display = 'none';
        } else {
            console.error('Erro ao carregar questão:', error);
            questionTitleElement.textContent = 'Erro ao carregar a questão';
        }
    }
}

function checkAnswer() {
    if (!currentQuestionData) return;
    
    let isCorrect = false;
    let userAnswer = '';
    let correctAnswer = '';
    
    if (currentQuestionData.tipo === 'texto') {
        const userInput = document.getElementById('translation-input').value.trim();
        userAnswer = userInput;
        const correctOptions = currentQuestionData.answer.map(ans => ans.toLowerCase());
        isCorrect = correctOptions.includes(userAnswer.toLowerCase());
        correctAnswer = currentQuestionData.answer.join(' ou ');
    } else if (currentQuestionData.tipo === 'multipla-escolha') {
        const correctOption = currentQuestionData.respostas.find(r => r.correta);
        const selectedOption = document.querySelector('.answer-option.selected');
        correctAnswer = correctOption ? correctOption.texto : '';
        if (selectedOption) {
            userAnswer = selectedOption.textContent;
            isCorrect = correctOption && (parseInt(selectedOption.dataset.id) === correctOption.id);
        } else {
            userAnswer = 'Nenhuma resposta';
        }
    }
    
    resultados.push({
        question: currentQuestionData.questao,
        userAnswer,
        correctAnswer,
        isCorrect
    });
    
    loadNextQuestion();
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

// --- INICIALIZAÇÃO DO QUIZ ---
// Evento do botão "Verificar" do quiz
nextButton.addEventListener('click', checkAnswer);

// Evento do formulário do usuário com fade
userDataForm.addEventListener('submit', (event) => {
    event.preventDefault();

    // Aplica fade-out no formulário
    applyFade(userDataContainer, 'out');

    setTimeout(() => {
        userDataContainer.style.display = 'none';
        quizContainer.style.display = 'block';

        // Aplica fade-in no quiz
        applyFade(quizContainer, 'in');

        // Carrega a primeira questão
        loadQuestion();
    }, 300); 
});
