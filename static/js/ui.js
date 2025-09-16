
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
                <div class="card-header">Questão</div>
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
                <div class="card-header">Sua Resposta</div>
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
            <p>Parabéns, você concluiu o quiz! 🎉</p>
            <div class="score-container">
                <p class="score-correct"><strong>Acertos:</strong> ${acertos}</p>
                <p class="score-incorrect"><strong>Erros:</strong> ${erros}</p>
            </div>
        </div>
    `;
    
    const correctAnswers = resultados.filter(r => r.isCorrect);
    if (correctAnswers.length > 0) {
        resultsHTML += '<div class="detailed-results"> <h3>Respostas Corretas:</h3><ul class="results-list correct-list">';
        correctAnswers.forEach(res => {
            resultsHTML += `
                <li>
                    <p><strong>Questão:</strong> ${res.question}</p>
                    <p><strong>Sua resposta:</strong> <span class="correct-answer">${res.userAnswer}</span></p>
                </li>
            `;
        });
        resultsHTML += '</ul>';
    }
    
    resultsHTML += '</div>';

    const incorrectAnswers = resultados.filter(r => !r.isCorrect);
    if (incorrectAnswers.length > 0) {
        resultsHTML += '<div class="detailed-results"> <h3>Respostas Erradas:</h3><ul class="results-list incorrect-list">';
        incorrectAnswers.forEach(res => {
            resultsHTML += `
                <li>
                    <p><strong>Questão:</strong> ${res.question}</p>
                    <p><strong>Sua resposta:</strong> <span class="user-answer">${res.userAnswer}</span></p>
                    <p><strong>Resposta correta:</strong> <span class="correct-answer">${res.correctAnswer}</span></p>
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