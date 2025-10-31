# -*- coding: utf-8 -*-
"""
calculo_nivel.py

Módulo para calcular o nível de proficiência CELPE-Bras com base 
no modelo Rasch.
"""

import numpy as np
from scipy.optimize import minimize

# --- Constantes de Limiar ---
# (Definidos empiricamente no seu script original)
_LIMIAR_INTERMEDIARIO = 0.0
_LIMIAR_AVANCADO = 1.2
_LIMIAR_AVANCADO_SUPERIOR = 1.8

# --- 1. Funções internas do Modelo Rasch ---

def _rasch_likelihood(theta, responses, difficulties):
    """Função de verossimilhança (interna)."""
    p = 1 / (1 + np.exp(-(theta - np.array(difficulties))))
    
    # Adiciona 1e-10 para evitar log(0)
    likelihood = np.prod(p**responses * (1 - p)**(1 - np.array(responses)))
    return -np.log(likelihood + 1e-10)

def _estimate_theta(responses, difficulties):
    """Estima o parâmetro theta (proficiência) (função interna)."""
    res = minimize(lambda th: _rasch_likelihood(th, responses, difficulties),
                   x0=[0], 
                   bounds=[(-4, 4)]) # Limites razoáveis para proficiência
    return res.x[0]

# --- 2. Classificação (interna) ---

def _classificar_celpe_bras(theta):
    """Classifica o valor de theta no nível CELPE-Bras (função interna)."""
    if theta < _LIMIAR_INTERMEDIARIO:
        return "Intermediário"
    elif _LIMIAR_INTERMEDIARIO <= theta < _LIMIAR_AVANCADO:
        return "Intermediário Superior"
    elif _LIMIAR_AVANCADO <= theta < _LIMIAR_AVANCADO_SUPERIOR:
        return "Avançado"
    else:
        return "Avançado Superior"

# --- 3. Função Pública Principal ---

def calcular_nivel_proficiencia(respostas, dificuldades):
    """
    Calcula o nível de proficiência CELPE-Bras de um candidato.

    Esta é a função principal a ser importada por outros scripts.

    Args:
        respostas (list): Uma lista de respostas (0 para erro, 1 para acerto).
        dificuldades (list): Uma lista dos parâmetros de dificuldade (em logits) 
                             correspondentes a cada item em 'respostas'.

    Returns:
        str: A string do nível de proficiência (ex: "Avançado").
    """
    # 1. Estimar a proficiência (theta)
    theta_estimado = _estimate_theta(respostas, dificuldades)
    
    # 2. Classificar o theta no nível correspondente
    nivel = _classificar_celpe_bras(theta_estimado)
    
    return nivel

# --- Bloco de Teste ---
# Este código só será executado se você rodar "python calculo_nivel.py"
# diretamente no terminal. Ele não será executado ao importar o módulo.
if __name__ == "__main__":
    
    print("Testando o módulo calculo_nivel.py...")
    
    # Exemplo de aplicação (do seu script original)
    respostas_ex = [1, 1, 0, 1, 0, 1]
    dificuldades_ex = [-1.0, 0.0, 1.0, 0.0, 1.0, -1.0] # fácil, médio, difícil, médio, difícil, fácil

    # Chamando a função principal
    nivel_aluno1 = calcular_nivel_proficiencia(respostas_ex, dificuldades_ex)
    
    print(f"\n--- Aluno 1 ---")
    print(f"Respostas: {respostas_ex}")
    print(f"Dificuldades: {dificuldades_ex}")
    print(f"Nível de Proficiência Calculado: {nivel_aluno1}")

    # Exemplo 2: Aluno com desempenho melhor
    respostas_ex_2 = [1, 1, 1, 1, 0, 1]
    nivel_aluno2 = calcular_nivel_proficiencia(respostas_ex_2, dificuldades_ex)
    
    print(f"\n--- Aluno 2 ---")
    print(f"Respostas: {respostas_ex_2}")
    print(f"Dificuldades: {dificuldades_ex}")
    print(f"Nível de Proficiência Calculado: {nivel_aluno2}")

    # Exemplo 3: Aluno com desempenho avançado
    respostas_ex_3 = [1, 1, 1, 1, 1, 1]
    nivel_aluno3 = calcular_nivel_proficiencia(respostas_ex_3, dificuldades_ex)
    
    print(f"\n--- Aluno 3 ---")
    print(f"Respostas: {respostas_ex_3}")
    print(f"Dificuldades: {dificuldades_ex}")
    print(f"Nível de Proficiência Calculado: {nivel_aluno3}")
    
'''  # Exemplo de main.py
import calculo_nivel

# Dados do aluno
respostas_aluno = [1, 1, 0, 1, 0, 1]
dificuldades_itens = [-1.0, 0.0, 1.0, 0.0, 1.0, -1.0]

# Calcular o nível
nivel = calculo_nivel.calcular_nivel_proficiencia(respostas_aluno, dificuldades_itens)

print(f"O nível de proficiência do aluno é: {nivel}")'''