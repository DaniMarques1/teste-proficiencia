// Aguarda o conteúdo da página ser totalmente carregado
document.addEventListener('DOMContentLoaded', function() {

    // --- LÓGICA PARA O BOTÃO DE ÁUDIO (TEXT-TO-SPEECH) ---
    const speakButton = document.getElementById('speak-button');
    
    if (speakButton) {
        speakButton.addEventListener('click', function() {
            const questionTextElement = document.getElementById('question-text');
            
            if (!questionTextElement || !questionTextElement.textContent) {
                alert('There is no text to read');
                return;
            }
            
            if ('speechSynthesis' in window) {
                const utterance = new SpeechSynthesisUtterance(questionTextElement.textContent);
                utterance.lang = 'pt-BR';
                window.speechSynthesis.speak(utterance);
            } else {
                alert('Sorry, your browser does not support text reading funcionalities.');
            }
        });
    }

    // --- LÓGICA PARA O BOTÃO DE MICROFONE (SPEECH-TO-TEXT) ---
    const micButton = document.getElementById('mic-button');
    const translationInput = document.getElementById('translation-input');
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

    if (!micButton || !translationInput) {
        console.error("Microphone elements not found.");
        return;
    }

    if (SpeechRecognition) {
        const recognition = new SpeechRecognition();

        // Configurações do reconhecimento de voz
        recognition.lang = 'pt-BR';
        recognition.interimResults = true; // Mostra resultados parciais
        recognition.continuous = false;    // Para de gravar após uma pausa

        // Evento de clique no botão do microfone para iniciar o reconhecimento
        micButton.addEventListener('click', () => {
            micButton.classList.add('is-listening');
            translationInput.value = ''; // Limpa o campo de texto
            recognition.start();
        });

        // Processa o resultado da fala em tempo real
        recognition.addEventListener('result', (event) => {
            const transcript = Array.from(event.results)
                .map(result => result[0])
                .map(result => result.transcript)
                .join('');
            
            // Remove a pontuação final (., ? !) para não interferir em validações
            translationInput.value = transcript.replace(/[\.,\?!]$/, '');
        });

        // Remove o feedback visual quando a escuta terminar
        recognition.addEventListener('end', () => {
            micButton.classList.remove('is-listening');
        });
        
        // Trata possíveis erros durante o reconhecimento
        recognition.addEventListener('error', (event) => {
            alert('Voice recognition error: ' + event.error);
            micButton.classList.remove('is-listening');
        });

    } else {
        // Desabilita o botão se o navegador não for compatível
        micButton.disabled = true;
        micButton.title = 'Your browser does not support voice recognition.';
        alert('Sorry, your browser does not support voice recognition.');
    }
});