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

const codeVerificationContainer = document.getElementById('code-verification-container');
const codeVerificationForm = document.getElementById('code-verification-form');
const codeInput = document.getElementById('code-input');
const codeErrorMessage = document.getElementById('code-error-message');

async function loadQuestion() {
    try {
        const data = await fetchQuestion(currentQuestionId);
        currentQuestionData = data;
        
        // --- Linha modificada ---
        questionTitleElement.textContent = `Questão ${questionNumber}`; 
        
        renderQuestionUI(data, cardsContainer);
        
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

    // 1️⃣ Mostra o loader assim que o quiz desaparecer
    setTimeout(() => {
        quizContainer.style.display = 'none';
        feedbackContainer.style.display = 'block';

        // Define o HTML do loader
        feedbackContainer.innerHTML = `
            <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 300px; text-align: center;">
                <div class="spinner"></div> 
                <p style="font-size: 1.2rem; margin-top: 20px;">Loading results...</p>
            </div>
        `;
        
        requestAnimationFrame(() => applyFade(feedbackContainer, 'in'));
    }, 300); // 300ms = tempo do seu fade-out

    try {
        const reportData = await sendResultsToBackend(); // <- Chamada principal
        const teachers = await fetchTeachers();

        displayFeedbackScreen(
            resultados,
            teachers,
            questionTitleElement,
            feedbackContainer,
            reportData?.pontos_fortes || [],
            reportData?.pontos_a_desenvolver || []
        );

        // 4️⃣ Re-adiciona os event listeners aos novos botões
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

    } catch (error) {
        // 5️⃣ Em caso de erro, substitui o loader pela mensagem de erro
        console.error("Erro ao finalizar quiz:", error);
        questionTitleElement.textContent = 'Erro ao carregar resultados';
        feedbackContainer.innerHTML = `<p>Não foi possível carregar as recomendações. Tente novamente mais tarde.</p>`;
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

    const acertos = resultados.filter(r => r.isCorrect).length;
    const total_questoes = resultados.length;
    const nota_final = Math.round((acertos / total_questoes) * 100); 

    const nome_aluno = document.getElementById('user-name')?.value || "Aluno";
    const email_aluno = document.getElementById('user-email')?.value || null;

    const payload = {
        nome_aluno,
        email_destinatario: email_aluno, 
        respostas,
        nivel: "A1 Intermediário", 
        nota_final,
        acertos,
        total_questoes,
        pdf: true 
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
            console.log("✅ Análise da IA recebida com sucesso:", data);
            return data; 
        } else {
            alert("Erro ao gerar feedback: " + (data.erro || "Erro desconhecido"));
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

function iniciarQuiz() {
    console.log("Iniciando o Quiz (preparando tela de apresentação)...");
}

// --- INICIALIZAÇÃO E EVENTOS ---

nextButton.addEventListener('click', checkAnswer);

const csrftoken = getCookie('csrftoken'); 

userDataForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const formData = new FormData(userDataForm);
    document.querySelectorAll('.error-message').forEach(el => el.remove());

    // --- 1️⃣ Começa o fade imediatamente ---
    applyFade(userDataContainer, 'out');
    
    setTimeout(() => {
        userDataContainer.style.display = 'none';

        if (codeVerificationContainer) {
            codeVerificationContainer.style.display = 'block';
            requestAnimationFrame(() => applyFade(codeVerificationContainer, 'in'));
            codeInput.focus();
        } else {
            console.error('Erro: O container de verificação de código não foi encontrado!');
        }
    }, 300);

    // --- 2️⃣ Executa o fetch em paralelo ---
    const csrftoken = getCookie('csrftoken');

    fetch('/api/salvar-usuario/', {
        method: 'POST',
        body: formData,
        headers: { 'X-CSRFToken': csrftoken }
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'code_sent') {
            console.log("Código enviado com sucesso.");
        } else if (data.status === 'error') {
            // --- 3️⃣ Em caso de erro, volta para o formulário ---
            revertToUserFormWithErrors(data.errors);
        }
    })
    .catch(error => {
        console.error('Erro na requisição:', error);
        alert('Ocorreu um erro de comunicação com o servidor.');
        revertToUserFormWithErrors(); // volta para o form
    });
});

// Função auxiliar para voltar ao form se der erro
function revertToUserFormWithErrors(errors = {}) {
    applyFade(codeVerificationContainer, 'out');
    setTimeout(() => {
        codeVerificationContainer.style.display = 'none';
        userDataContainer.style.display = 'block';
        requestAnimationFrame(() => applyFade(userDataContainer, 'in'));

        // Se tiver erros de validação, exibe
        for (const field in errors) {
            const errorList = errors[field];
            if (errorList && errorList.length > 0) {
                const message = errorList[0].message;
                const inputField = userDataForm.querySelector(`[name="${field}"]`);
                if (inputField) {
                    const errorEl = document.createElement('div');
                    errorEl.className = 'error-message';
                    errorEl.textContent = message;
                    errorEl.style.color = 'red';
                    errorEl.style.fontSize = '0.9rem';
                    inputField.parentElement.appendChild(errorEl);
                }
            }
        }
    }, 300);
}


if (codeVerificationForm) {
    codeVerificationForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const code = codeInput.value;
        codeErrorMessage.textContent = ''; // Limpa erros antigos

        if (!code || code.length < 6) {
            codeErrorMessage.textContent = 'Please, input the 6-digit code.';
            return;
        }

    fetch('/api/verificar-codigo/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrftoken
        },
        body: JSON.stringify({ code: code })
    })
    .then(async response => {
        const data = await response.json().catch(() => ({})); // evita erro se não for JSON
        if (!response.ok) {
            // Se o backend retornou 400, ainda tratamos o conteúdo
            throw data;
        }
        return data;
    })
    .then(data => {
        if (data.status === 'success') {
            // Código correto
            applyFade(codeVerificationContainer, 'out');
            setTimeout(() => {
                codeVerificationContainer.style.display = 'none';
                const presentation = document.getElementById('presentation-container');
                if (presentation) {
                    presentation.style.display = 'block';
                    requestAnimationFrame(() => applyFade(presentation, 'in'));
                }
                iniciarQuiz();
            }, 300);
        } else {
            // Mesmo se vier status=success mas algo estranho
            codeErrorMessage.textContent = data.message || 'Ocorreu um erro.';
        }
    })
    .catch(error => {
        console.error('Erro na verificação:', error);
        codeErrorMessage.textContent = error.message || 'Código inválido ou sessão expirada.';
        codeInput.focus();
        codeInput.select();
    });
    });
}


skipAuthButton.addEventListener('click', (event) => {
    event.preventDefault();
    const userDataContainer = document.getElementById('user-data-container');
    applyFade(userDataContainer, 'out');
    
    setTimeout(() => {
        userDataContainer.style.display = 'none';
        const quizContainer = document.getElementById('presentation-container'); 
        
        if (quizContainer) {
            quizContainer.style.display = 'block';
            requestAnimationFrame(() => applyFade(quizContainer, 'in'));
        } else {
            console.error('Error: The quiz container was not found!');
        }
        iniciarQuiz(); 
    }, 300); 
});

function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

startQuizButton.addEventListener('click', () => {
    applyFade(presentationContainer, 'out');
    setTimeout(() => {
        presentationContainer.style.display = 'none';
        quizContainer.style.display = 'block';
        requestAnimationFrame(() => applyFade(quizContainer, 'in'));
        loadQuestion();
    }, 300);
});