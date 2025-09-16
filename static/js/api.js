/**
 * Busca os dados de uma questão específica da API.
 * @param {number} questionId O ID da questão a ser buscada.
 * @returns {Promise<Object>} Os dados da questão.
 * @throws {Error} Lança um erro se a questão não for encontrada ou houver falha na rede.
 */
export async function fetchQuestion(questionId) {
    const response = await fetch(`/api/question/${questionId}`);
    
    if (!response.ok) {
        // Lança um erro com o status para que o chamador possa tratá-lo
        const error = new Error('Falha ao buscar a questão');
        error.status = response.status;
        throw error;
    }
    
    return await response.json();
}