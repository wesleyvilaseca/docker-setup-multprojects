#!/bin/bash

# Script para acessar shell dos containers
SERVICE=${1:-"php"}

case $SERVICE in
    "php")
        echo "🐘 Acessando shell do PHP..."
        docker-compose exec php bash
        ;;
    "node")
        echo "🟢 Acessando shell do Node.js..."
        docker-compose exec node sh
        ;;
    "nginx")
        echo "🌐 Acessando shell do Nginx..."
        docker-compose exec nginx sh
        ;;
    "mongodb")
        echo "🍃 Acessando shell do MongoDB..."
        docker-compose exec mongodb mongosh
        ;;
    "redis")
        echo "🔴 Acessando shell do Redis..."
        docker-compose exec redis redis-cli
        ;;
    *)
        echo "❌ Serviço não encontrado: $SERVICE"
        echo ""
        echo "Serviços disponíveis:"
        echo "   • php - Container PHP/Laravel"
        echo "   • node - Container Node.js"
        echo "   • nginx - Container Nginx"
        echo "   • mongodb - Container MongoDB"
        echo "   • redis - Container Redis"
        echo ""
        echo "Uso: ./scripts/shell.sh [serviço]"
        exit 1
        ;;
esac
