FROM python:3.11-slim

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libpq-dev \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Definir diretório de trabalho
WORKDIR /var/www/projects

# Instalar dependências Python comuns
RUN pip install --no-cache-dir \
    pipenv \
    poetry \
    django \
    flask \
    fastapi \
    uvicorn \
    gunicorn \
    psycopg2-binary \
    redis \
    celery \
    requests \
    pymongo \
    python-dotenv

# Criar usuário não-root
RUN useradd -m -s /bin/bash python && \
    chown -R python:python /var/www/projects
USER python

# Expor porta padrão
EXPOSE 8000

# Comando padrão (manter container vivo para desenvolvimento)
# Usando tail -f /dev/null que funciona melhor com usuário não-root
CMD ["sh", "-c", "tail -f /dev/null"]
