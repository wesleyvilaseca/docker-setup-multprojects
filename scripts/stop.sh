#!/bin/bash

# Script para parar o ambiente de desenvolvimento
echo "🛑 Parando ambiente de desenvolvimento Docker..."

# Parar containers
docker-compose down

echo "✅ Ambiente parado com sucesso!"
