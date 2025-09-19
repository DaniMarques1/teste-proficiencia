
/**
 * Renderiza a interface da questão no container principal.
 * @param {Object} question - O objeto da questão.
 * @param {HTMLElement} container - O elemento onde o HTML será inserido.
 */
export function renderQuestionUI(question, container) {
    container.innerHTML = ''; // Limpa o conteúdo anterior
    let questionHTML = '';

    if (question.tipo === 'texto') {
        questionHTML = `
            <div class="card">
                <div class="card-header">Question</div>
                <div class="card-content">
                    <span class="text text-to-speak" style="font-size: 1.4em; font-weight: normal;">${question.texto}</span>
                    <button class="icon-button speak-button"><i class="fas fa-volume-up"></i></button>
                </div>
            </div>
            <div class="card">
                <div class="card-content">
                    <span id="question-text" class="text text-to-speak">${question.questao}</span>
                    <button class="icon-button speak-button"><i class="fas fa-volume-up"></i></button>
                </div>
            </div>
            <div class="card">
                <div class="card-header">Your answer</div>
                <div class="card-content">
                    <input type="text" id="translation-input" placeholder="Digite a tradução...">
                    <button class="icon-button microphone" id="mic-button"><i class="fas fa-microphone"></i></button>
                </div>
            </div>
        `;
        container.innerHTML = questionHTML;
        
    } else if (question.tipo === 'multipla-escolha') {
        questionHTML = `
            <div class="card">
                <div class="card-content">
                    <span id="question-text" class="text text-to-speak">${question.questao}</span>
                    <button class="icon-button speak-button"><i class="fas fa-volume-up"></i></button>
                </div>
            </div>
        `;
        container.innerHTML = questionHTML;

        const optionsContainer = document.createElement('div');
        optionsContainer.className = 'answer-options-container';
        question.respostas.forEach(resposta => {
            const button = document.createElement('button');
            button.className = 'answer-option';
            button.textContent = resposta.texto;
            button.dataset.id = resposta.id;
            button.addEventListener('click', () => {
                document.querySelectorAll('.answer-option.selected').forEach(btn => btn.classList.remove('selected'));
                button.classList.add('selected');
            });
            optionsContainer.appendChild(button);
        });
        container.appendChild(optionsContainer);
    }
}

// ui.js

/**
 * Exibe a tela de feedback do quiz com um resumo e sugestões de professores.
 * @param {Array} resultados - O array com os resultados de cada questão.
 * @param {Array} teachers - NOVO: O array com os dados dos professores vindos da API.
 * @param {HTMLElement} titleElement - O elemento do título principal.
 * @param {HTMLElement} container - O elemento onde o feedback será renderizado.
 */
// 1. Adicione 'teachers' como um novo parâmetro
export function displayFeedbackScreen(resultados, teachers, titleElement, container) {
    titleElement.textContent = 'Quiz Results';
    container.innerHTML = '';

    const totalQuestoes = resultados.length;
    const acertos = resultados.filter(r => r.isCorrect).length;

    const strengths = ["Use of Simple Past Tense", "Food Vocabulary", "Gender Agreement"];
    const improvements = ["Use of the Subjunctive", "Difference between 'ser' and 'estar'", "Object Pronouns"];
    
    let teachersHTML = '';
    if (teachers && teachers.length > 0) {
        teachers.forEach(teacher => {
            teachersHTML += `
                <div class="teacher-card">
                    <img src="${teacher.photo_url}" alt="Photo of ${teacher.name}" class="teacher-photo">
                    <div class="teacher-info">
                        <h4>${teacher.name}</h4>
                        <span class="teacher-langs">${teacher.native_langs}</span>
                        <p>${teacher.description}</p>
                        <a href="${teacher.link}" target="_blank" rel="noopener noreferrer" class="feedback-button">Take Class</a>
                    </div>
                </div>
            `;
        });
    } else {
        teachersHTML = `<p>No teacher found at this moment!</p>`;
    }

    const feedbackHTML = `
        <div class="feedback-grid-container">
            <div class="feedback-summary-panel">
                <h2>Quiz Results</h2>
                <h3>${acertos} / ${totalQuestoes} Right Answers</h3>

                <div class="feedback-section">
                    <h4><i class="fas fa-check-circle"></i> Strengths</h4>
                    <ul>
                        ${strengths.map(item => `<li>${item}</li>`).join('')}
                    </ul>
                </div>

                <div class="feedback-section">
                    <h4><i class="fas fa-crosshairs"></i> Areas for Improvement</h4>
                    <ul>
                        ${improvements.map(item => `<li>${item}</li>`).join('')}
                    </ul>
                </div>
                
                <div class="feedback-actions">
                    <button class="feedback-button email-button" id="get-results-button">Get Results by Email</button>
                    <button class="feedback-button" id="show-details-button">See Responses</button>
                </div>

            </div>

            <div class="feedback-teachers-panel">
                <div class="congratulations-section">
                    <h3>Congratulations!</h3>
                    <p>Thank you for participating in the quiz! If you're looking to improve your Portuguese, connect with a teacher on our platform:</p>
                </div>
                ${teachersHTML}
            </div>
        </div>
    `;

    container.innerHTML = feedbackHTML;
}


/**
 * Exibe a tela de finalização do quiz com os resultados.
 * @param {Array} resultados - O array com os resultados de cada questão.
 * @param {HTMLElement} titleElement - O elemento do título principal.
 * @param {HTMLElement} container - O elemento principal do quiz.
 */
export function displayQuizFinished(resultados, titleElement, container) {
    titleElement.textContent = 'Quiz Finalizado!';
    
    const acertos = resultados.filter(r => r.isCorrect).length;
    const erros = resultados.filter(r => !r.isCorrect).length;

    let resultsHTML = `
        <div class="quiz-summary">
            <p>Congratulations, you have completed the quiz! 🎉</p>
            <div class="score-container">
                <p class="score-correct"><strong>Right:</strong> ${acertos}</p>
                <p class="score-incorrect"><strong>Wrong:</strong> ${erros}</p>
            </div>
        </div>
        <div style="text-align: center; padding: 10px;"> <button class="feedback-button email-button" id="get-results-button">Get Results by Email</button> </div>
    `;
    
    const correctAnswers = resultados.filter(r => r.isCorrect);
    if (correctAnswers.length > 0) {
        resultsHTML += '<div class="detailed-results"> <h3>Right Answers:</h3><ul class="results-list correct-list">';
        correctAnswers.forEach(res => {
            resultsHTML += `
                <li>
                    <p><strong>Question:</strong> ${res.question}</p>
                    <p><strong>Your answer:</strong> <span class="correct-answer">${res.userAnswer || 'No answer'}</span></p>
                </li>
            `;
        });
        resultsHTML += '</ul>';
    }
    
    resultsHTML += '</div>';

    const incorrectAnswers = resultados.filter(r => !r.isCorrect);
    if (incorrectAnswers.length > 0) {
        resultsHTML += '<div class="detailed-results"> <h3>Wrong answers:</h3><ul class="results-list incorrect-list">';
        incorrectAnswers.forEach(res => {
            resultsHTML += `
                <li>
                    <p><strong>Question:</strong> ${res.question}</p>
                    <p><strong>Your answer:</strong> <span class="user-answer">${res.userAnswer || 'No answer'}</span></p>
                    <p><strong>Right answer:</strong> <span class="correct-answer">${res.correctAnswer}</span></p>
                </li>
            `;
        });
        resultsHTML += '</ul>';
    }

    resultsHTML += '</div>';
    container.innerHTML = resultsHTML;
}

/**
 * Aplica um efeito de fade out em um elemento.
 * @param {HTMLElement} element 
 */
export function applyFade(element, effect = 'out') {
    if (effect === 'out') {
        element.classList.add('fade-out');
    } else {
        element.classList.remove('fade-out');
    }
}