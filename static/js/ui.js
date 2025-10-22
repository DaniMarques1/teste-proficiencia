
/**
 * Renderiza a interface da questão no container principal.
 * @param {Object} question - O objeto da questão.
 * @param {HTMLElement} container - O elemento onde o HTML será inserido.
 */
export function renderQuestionUI(question, container) {
    container.innerHTML = ''; // Limpa o conteúdo anterior
    let questionHTML = '';

    if (question.tipo === 'multipla') {
        questionHTML = `
            <div class="card">
                <div class="card-header">Question</div>
                <div class="card-content">
                    <span class="text text-to-speak" style="font-size: 1.4em; font-weight: normal;">${question.texto}</span>
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

    } else if (question.tipo === 'unica') {
        questionHTML = `
            <div class="card">
                <div class="card-content">
                    <span id="question-text" class="text text-to-speak">${question.texto}</span>
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
            button.textContent = resposta.resposta;
            button.dataset.id = resposta.id;
            button.addEventListener('click', () => {
                document.querySelectorAll('.answer-option.selected').forEach(btn => btn.classList.remove('selected'));
                button.classList.add('selected');
            });
            optionsContainer.appendChild(button);
        });

        container.appendChild(optionsContainer);
    }

    // === Lógica de leitura de texto ===
    const speakButtons = container.querySelectorAll('.speak-button');
        speakButtons.forEach(button => {
            button.addEventListener('click', () => {
                // Pega o texto da questão
                const questionText = container.querySelector('.text-to-speak')?.textContent || '';

                // --- LINHA DE CORREÇÃO ADICIONADA ---
                // Substitui um ou mais underscores por uma vírgula (pausa),
                // garantindo comportamento consistente em todos os navegadores.
                const cleanQuestionText = questionText.replace(/_+/g, ', ');

                // Pega as opções (caso existam)
                const options = Array.from(container.querySelectorAll('.answer-option'))
                    .map(btn => btn.textContent)
                    .join(', ');

                // Combina questão + respostas (USANDO O TEXTO LIMPO)
                const fullText = options ? `${cleanQuestionText}. Opções: ${options}.` : cleanQuestionText;

                // Cancela qualquer leitura anterior e fala o novo texto
                speechSynthesis.cancel();
                const utterance = new SpeechSynthesisUtterance(fullText);
                utterance.lang = 'pt-BR'; 
                speechSynthesis.speak(utterance);
            });
        });
}

/**
 * Exibe a tela de feedback do quiz com um resumo e sugestões de professores.
 * @param {Array} resultados - O array com os resultados de cada questão.
 * @param {Array} teachers - NOVO: O array com os dados dos professores vindos da API.
 * @param {HTMLElement} titleElement - O elemento do título principal.
 * @param {HTMLElement} container - O elemento onde o feedback será renderizado.
 */

export function displayFeedbackScreen(
    resultados,
    teachers,
    titleElement,
    container,
    strengths = [],
    improvements = []
) {
    titleElement.textContent = 'Quiz Results';
    container.innerHTML = '';

    const totalQuestoes = resultados.length;
    const acertos = resultados.filter(r => r.isCorrect).length;

    // fallback se IA não retornar
    if (strengths.length === 0) strengths = ["Compreensão geral boa.", "Vocabulário básico sólido."];
    if (improvements.length === 0) improvements = ["Precisa revisar tempos verbais.", "Melhorar ortografia."];
    
    let teachersHTML = '';
    if (teachers && teachers.length > 0) {
        teachers.forEach(teacher => {
            teachersHTML += `
                <div class="teacher-card">
                    <img src="${teacher.foto_url}" alt="Photo of ${teacher.nome}" class="teacher-photo">
                    <div class="teacher-info">
                        <h4>${teacher.nome}</h4>
                        <span class="teacher-langs">${teacher.linguas}</span>
                        <p>${teacher.texto}</p>
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
                    <button class="feedback-button" id="show-details-button">See Responses</button>
                </div>

            </div>

            <div class="feedback-teachers-panel">
                <div class="congratulations-section">
                    <h3>Congratulations!</h3>
                    <p>Thank you for participating in the quiz! Your results was sent to your e-mail inbox. If you're looking to improve your Portuguese, connect with a teacher on our platform:</p>
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
    `;
    
    const correctAnswers = resultados.filter(r => r.isCorrect);
    if (correctAnswers.length > 0) {
        resultsHTML += '<div class="detailed-results"> <h3>Right Answers:</h3><ul class="results-list correct-list">';
        correctAnswers.forEach(res => {
            // Adicionamos um parágrafo para a explicação se ela existir
            resultsHTML += `
                <li>
                    <p><strong>Question:</strong> ${res.question}</p>
                    <p><strong>Your answer:</strong> <span class="correct-answer">${res.userAnswer || 'No answer'}</span></p>
                    ${res.explicacao ? `<p><strong>Explanation:</strong> <span class="explanation-text">${res.explicacao}</span></p>` : ''}
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
            // Adicionamos também a explicação para as respostas incorretas
            resultsHTML += `
                <li>
                    <p><strong>Question:</strong> ${res.question}</p>
                    <p><strong>Your answer:</strong> <span class="user-answer">${res.userAnswer || 'No answer'}</span></p>
                    <p><strong>Right answer:</strong> <span class="correct-answer">${res.correctAnswer}</span></p>
                    ${res.explicacao ? `<p><strong>Explanation:</strong> <span class="explanation-text">${res.explicacao}</span></p>` : ''}
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