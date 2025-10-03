// api.js

/**
 * Busca a lista ordenada de IDs de todas as questões disponíveis.
 * @returns {Promise<Array<number>>} Uma promessa que resolve para um array de IDs.
 */
export async function fetchQuestionList() {
    const response = await fetch(`/questions/`); // Novo endpoint
    
    if (!response.ok) {
        const error = new Error('Falha ao buscar a lista de questões');
        error.status = response.status;
        throw error;
    }
    
    return await response.json();
}

/**
 * Busca os dados de uma única questão pelo ID.
 * @param {number} questionId O ID da questão a ser buscada.
 * @returns {Promise<Object>} Os dados da questão.
 */
export async function fetchQuestion(questionId) {
    const response = await fetch(`/question/${questionId}`);
    
    if (!response.ok) {
        const error = new Error('Falha ao buscar a questão');
        error.status = response.status;
        throw error;
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