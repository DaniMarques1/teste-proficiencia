// api.js

/**
 * Busca os dados de uma questão específica da API.
 * @param {number} questionId O ID da questão a ser buscada.
 * @returns {Promise<Object>} Os dados da questão.
 */
export async function fetchQuestion(questionId) {
    const response = await fetch(`/api/question/${questionId}`);
    
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
    const response = await fetch(`/api/teacher/${teacherId}`);

    if (!response.ok) {
        const error = new Error('Falha ao buscar o professor');
        error.status = response.status;
        throw error;
    }
    
    return await response.json();
}

/**
 * NOVO: Busca a LISTA de professores da API.
 * @returns {Promise<Array>} Um array com os dados dos professores.
 */
export async function fetchTeachers() {
    // Note o endpoint no plural: 'teachers'
    const response = await fetch(`/api/teachers/`); 

    if (!response.ok) {
        const error = new Error('Falha ao buscar a lista de professores');
        error.status = response.status;
        throw error;
    }
    
    return await response.json();
}