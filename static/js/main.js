import { fetchQuestion, fetchTeachers } from './api.js'; 
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
// 2. Adicione o novo container de feedback
const feedbackContainer = document.getElementById('feedback-container');
const questionTitleElement = document.getElementById('question-title');
const cardsContainer = document.getElementById('cards-container');
const nextButton = document.getElementById('next-button');

// --- FUNÇÕES DE CONTROLE DO QUIZ ---
async function loadQuestion() {
    try {
        const data = await fetchQuestion(currentQuestionId);
        currentQuestionData = data;
        
        questionTitleElement.textContent = `Question ${data.id}: ${data.header}`;
        renderQuestionUI(data, cardsContainer);
        initializeAudioFeatures();
        
        const textInput = document.getElementById('translation-input');
        if (textInput) {
            textInput.addEventListener('keyup', handleEnterKey);
        }
    } catch (error) {
        // 3. Quando o quiz acabar (erro 404), chame a nova função handleQuizEnd
        if (error.status === 404) {
            handleQuizEnd();
        } else {
            console.error('Error loading question:', error);
            questionTitleElement.textContent = 'Error loading question';
        }
    }
}

/**
 * 4. Nova função para gerenciar a transição para a tela de feedback.
 * Isso organiza melhor o código que estava no 'catch'.
 */
async function handleQuizEnd() {
    applyFade(quizContainer, 'out');
    nextButton.style.display = 'none';

    try {
        const teachers = await fetchTeachers();

        setTimeout(() => {
            quizContainer.style.display = 'none';
            feedbackContainer.style.display = 'block';
            
            displayFeedbackScreen(resultados, teachers, questionTitleElement, feedbackContainer);
            applyFade(feedbackContainer, 'in');

            // --- LÓGICA DOS BOTÕES ATUALIZADA ---
            const emailButton = document.getElementById('get-results-button');
            const showDetailsButton = document.getElementById('show-details-button');
            
            // Ação para o botão de Email (atualmente, só exibe um alerta)
            if (emailButton) {
                emailButton.addEventListener('click', () => {
                    alert('Funcionalidade de envio de email a ser implementada!');
                    // Aqui você chamaria a função para enviar os resultados para o backend
                });
            }
            
            // Ação para o botão de ver respostas detalhadas
            if (showDetailsButton) {
                showDetailsButton.addEventListener('click', () => {
                    applyFade(feedbackContainer, 'out');
                    setTimeout(() => {
                        // Mostra a lista de respostas corretas e incorretas
                        displayQuizFinished(resultados, questionTitleElement, feedbackContainer);
                        applyFade(feedbackContainer, 'in');
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
        correctAnswer = currentQuestionData.answer.join(' or ');
    } else if (currentQuestionData.tipo === 'multipla-escolha') {
        const correctOption = currentQuestionData.respostas.find(r => r.correta);
        const selectedOption = document.querySelector('.answer-option.selected');
        correctAnswer = correctOption ? correctOption.texto : '';
        if (selectedOption) {
            userAnswer = selectedOption.textContent;
            isCorrect = correctOption && (parseInt(selectedOption.dataset.id) === correctOption.id);
        } else {
            userAnswer = 'No answer';
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
            // Remove o fade-out para a próxima questão aparecer
            cardsContainer.classList.remove('fade-out');
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
nextButton.addEventListener('click', checkAnswer);

userDataForm.addEventListener('submit', (event) => {
    event.preventDefault();
    applyFade(userDataContainer, 'out');
    setTimeout(() => {
        userDataContainer.style.display = 'none';
        quizContainer.style.display = 'block';
        applyFade(quizContainer, 'in');
        loadQuestion();
    }, 300); 
});