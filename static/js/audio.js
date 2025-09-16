let recognition;

// Configura o reconhecimento de voz uma única vez.
function setupRecognition() {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (SpeechRecognition) {
        recognition = new SpeechRecognition();
        recognition.lang = 'pt-BR'; // <<-- Idioma da resposta
        recognition.interimResults = true;
        recognition.continuous = false;
    }
}

/**
 * Anexa os listeners de evento para os botões de áudio (falar e microfone).
 * Esta função deve ser chamada toda vez que uma nova questão é renderizada.
 */
export function initializeAudioFeatures() {
    // 1. Text-to-Speech (Falar)
    // Seleciona TODOS os botões com a classe 'speak-button'
    const speakButtons = document.querySelectorAll('.speak-button');
    
    // Itera sobre cada botão encontrado
    speakButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Encontra o elemento de texto mais próximo DENTRO do mesmo '.card-content'
            const textElement = button.closest('.card-content').querySelector('.text-to-speak');
            const textToSpeak = textElement ? textElement.textContent : '';

            if ('speechSynthesis' in window && textToSpeak) {
                const utterance = new SpeechSynthesisUtterance(textToSpeak);
                utterance.lang = 'pt-BR'; // Idioma da pergunta
                window.speechSynthesis.speak(utterance);
            } else {
                alert('Seu navegador não suporta a funcionalidade de leitura de texto.');
            }
        });
    });

    // 2. Speech-to-Text (Microfone) - Esta parte permanece igual, pois o ID do microfone é único.
    const micButton = document.getElementById('mic-button');
    const translationInput = document.getElementById('translation-input');
    
    if (micButton && translationInput && recognition) {
        micButton.addEventListener('click', () => {
            micButton.classList.add('is-listening');
            translationInput.value = '';
            recognition.start();
        });

        recognition.onresult = (event) => {
            const transcript = Array.from(event.results)
                .map(result => result[0].transcript)
                .join('');
            translationInput.value = transcript.replace(/[\.,\?!]$/, '');
        };

        recognition.onend = () => micButton.classList.remove('is-listening');
        recognition.onerror = (event) => {
            alert('Erro no reconhecimento de voz: ' + event.error);
            micButton.classList.remove('is-listening');
        };
    } else if (micButton) {
        micButton.disabled = true;
        micButton.title = 'Reconhecimento de voz não é suportado.';
    }
}

// Inicializa a API de reconhecimento de voz assim que o módulo é carregado.
setupRecognition();