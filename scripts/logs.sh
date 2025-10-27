#!/bin/bash

# Script para visualizar logs dos containers
SERVICE=${1:-""}

if [ -z "$SERVICE" ]; then
    echo "📋 Logs disponíveis:"
    echo "   • nginx - Logs do Nginx"
    echo "   • php - Logs do PHP-FPM"
    echo "   • node - Logs do Node.js"
    echo "   • mongodb - Logs do MongoDB"
    echo "   • redis - Logs do Redis"
    echo "   • mailhog - Logs do Mailhog"
    echo ""
    echo "Uso: ./scripts/logs.sh [serviço]"
    echo "Exemplo: ./scripts/logs.sh nginx"
    exit 1
fi

echo "📋 Mostrando logs do serviço: $SERVICE"
echo "Pressione Ctrl+C para sair"
echo ""

docker-compose logs -f $SERVICE
