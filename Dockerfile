# Dockerfile (WeasyPrint corrigido para Debian 12 / Trixie)

FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev \
    # Dependências do WeasyPrint:
    libcairo2 \
    libcairo2-dev \
    libpango-1.0-0 \
    libpangoft2-1.0-0 \
    libgdk-pixbuf-2.0-0 \
    libffi-dev \
    shared-mime-info \
    fonts-dejavu-core \
    fonts-liberation \
    fonts-freefont-ttf \
    fonts-noto-core \
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
