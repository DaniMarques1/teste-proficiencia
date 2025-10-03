# Dockerfile (Corrigido)

# 1. Usar uma imagem oficial do Python como base
FROM python:3.10-slim

# 2. Definir variáveis de ambiente
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# --- LINHA ADICIONADA PARA CORRIGIR O ERRO ---
# Instala as dependências de sistema necessárias para compilar o mysqlclient
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# ----------------------------------------------

# 3. Criar e definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# 4. Copiar o arquivo de dependências e instalar
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiar o restante do código do projeto para o diretório de trabalho
COPY . .

RUN mkdir -p /app/staticfiles
RUN python manage.py collectstatic --noinput

# 6. Tornar o script de entrypoint executável
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 7. Expor a porta 8000 para que o Gunicorn possa ser acessado
EXPOSE 8000

# 8. Definir o comando para iniciar a aplicação
ENTRYPOINT ["/entrypoint.sh"]