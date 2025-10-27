#!/bin/bash

# Script para instalar pacotes Python
PROJECT_NAME=$1
PACKAGE=$2

if [ -z "$PROJECT_NAME" ] || [ -z "$PACKAGE" ]; then
    echo "❌ Uso: ./scripts/python-install.sh <projeto> <pacote>"
    echo ""
    echo "Exemplos:"
    echo "   ./scripts/python-install.sh meu-django django"
    echo "   ./scripts/python-install.sh minha-api flask"
    echo "   ./scripts/python-install.sh meu-fastapi fastapi"
    exit 1
fi

echo "📦 Instalando $PACKAGE no projeto $PROJECT_NAME..."

# Verificar se container está rodando
if ! docker-compose ps python | grep -q "Up"; then
    echo "❌ Container Python não está rodando. Execute: ./scripts/start.sh"
    exit 1
fi

# Instalar pacote
docker-compose exec python bash -c "cd $PROJECT_NAME && pip install $PACKAGE"

echo "✅ Pacote $PACKAGE instalado no projeto $PROJECT_NAME!"
echo "📝 Atualize o requirements.txt se necessário"
