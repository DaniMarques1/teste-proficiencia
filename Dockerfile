# Dockerfile (Corrigido + WeasyPrint)

# 1. Usar uma imagem oficial do Python como base
FROM python:3.10-slim

# 2. Definir variáveis de ambiente
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Instalar dependências de sistema (mysqlclient + WeasyPrint)
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    # Dependências do WeasyPrint:
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    libcairo2 \
    libcairo2-dev \
    libgdk-pixbuf2.0-0 \
    libffi-dev \
    shared-mime-info \
    fonts-dejavu-core \
    fonts-liberation \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. Criar e definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# 5. Copiar o arquivo de dependências e instalar
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copiar o restante do código do projeto
COPY . .

# 7. Preparar diretórios e assets estáticos
RUN mkdir -p /app/staticfiles
RUN python manage.py collectstatic --noinput

# 8. Tornar o script de entrypoint executável
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 9. Expor a porta 8000 para o Gunicorn
EXPOSE 8000

# 10. Definir o comando padrão
ENTRYPOINT ["/entrypoint.sh"]
