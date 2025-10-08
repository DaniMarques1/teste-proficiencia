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

/**
 * @param {number} questionId O ID da questão a ser buscada.
 * @returns {Promise<Object>} Os dados da questão.
 */
export async function fetchQuestion(questionId) {
    // ... (esta função continua igual)
    const response = await fetch(`/question/${questionId}`);
    if (!response.ok) {
        const error = new Error('Falha ao buscar a questão');
        error.status = response.status;
        throw error;
    }
    return await response.json();
}


/**
 * Envia a resposta do usuário para verificação no backend.
 * @param {number} questionId O ID da questão.
 * @param {number} userAnswerId O ID da resposta do usuário.
 * @returns {Promise<Object>} O resultado da verificação.
 */
export async function checkAnswerAPI(questionId, userAnswerId) {
    const csrftoken = getCookie('csrftoken');

    const response = await fetch('/check_answer/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            // 'X-CSRFToken': csrftoken
        },
        body: JSON.stringify({
            question_id: questionId,
            user_answer_id: userAnswerId
        })
    });

    if (!response.ok) {
        throw new Error('Falha ao verificar a resposta');
    }

    return await response.json();
}

/**
 * Busca os dados de UM professor específico da API.
 * @param {number} teacherId O ID do professor a ser buscado.
 * @returns {Promise<Object>} Os dados do professor.
 */
export async function fetchTeacher(teacherId) {
    const response = await fetch(`/teacher/${teacherId}`);

    if (!response.ok) {
        const error = new Error('Falha ao buscar o professor');
        error.status = response.status;
        throw error;
    }
    
    return await response.json();
}

/**
 * @returns {Promise<Array>} Um array com os dados dos professores.
 */
export async function fetchTeachers() {
    // Note o endpoint no plural: 'teachers'
    const response = await fetch(`/teachers/`); 

    if (!response.ok) {
        const error = new Error('Falha ao buscar a lista de professores');
        error.status = response.status;
        throw error;
    }
    
    return await response.json();
}