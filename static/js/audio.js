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
// audio.js

export function initializeAudioFeatures() {
    // 1. Text-to-Speech (Falar)
    const speakButtons = document.querySelectorAll('.speak-button');
    
    speakButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Encontra o container pai da questão
            const contentContainer = button.closest('.card-content');
            
            // --- LÓGICA MODIFICADA COMEÇA AQUI ---

            // Encontra TODOS os elementos de texto dentro do container
            const textElements = contentContainer.querySelectorAll('.text-to-speak');

            // Extrai o texto de cada elemento e junta em uma única string
            const textToSpeak = Array.from(textElements)
                                     .map(el => el.textContent.trim()) // Pega o texto de cada um
                                     .join('. '); // Junta com um ponto final para dar uma pausa natural


            if ('speechSynthesis' in window && textToSpeak) {
                const utterance = new SpeechSynthesisUtterance(textToSpeak);
                utterance.lang = 'pt-BR';
                window.speechSynthesis.speak(utterance);
            } else {
                alert('Seu navegador não suporta a funcionalidade de leitura de texto.');
            }
        });
    });
}

// Inicializa a API de reconhecimento de voz assim que o módulo é carregado.
setupRecognition();