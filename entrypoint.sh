#!/bin/sh
# entrypoint.sh

# Espera o banco de dados ficar pronto (opcional, mas recomendado)
# echo "Waiting for mysql..."
# while ! nc -z db 3306; do
#   sleep 0.1
# done
# echo "MySQL started"

# Aplica as migrations específicas do app 'contas'
echo "Applying migrations for 'contas'..."
python manage.py migrate contas --noinput

# Aplica as demais migrations (opcional)
echo "Applying remaining migrations..."
python manage.py migrate --noinput

# Inicia o servidor Gunicorn
echo "Starting Gunicorn..."
gunicorn config.wsgi:application --bind 0.0.0.0:8000
