#!/bin/bash

# Script para acessar container Python
echo "🐍 Acessando container Python..."

# Verificar se container está rodando
if ! docker-compose ps python | grep -q "Up"; then
    echo "❌ Container Python não está rodando. Execute: ./scripts/start.sh"
    exit 1
fi

# Acessar container
docker-compose exec python bash
