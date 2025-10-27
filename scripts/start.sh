#!/bin/bash

# Script para iniciar o ambiente de desenvolvimento
echo "🚀 Iniciando ambiente de desenvolvimento Docker..."

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

# Criar diretórios necessários
mkdir -p projects
mkdir -p ssl
mkdir -p logs/nginx
mkdir -p logs/php
mkdir -p logs/node

# Construir e iniciar containers
echo "📦 Construindo e iniciando containers..."
docker-compose up -d --build

# Aguardar containers iniciarem
echo "⏳ Aguardando containers iniciarem..."
sleep 10

# Verificar status dos containers
echo "🔍 Verificando status dos containers..."
docker-compose ps

# Mostrar informações úteis
echo ""
echo "✅ Ambiente iniciado com sucesso!"
echo ""
echo "🌐 Serviços disponíveis:"
echo "   • Nginx: http://localhost"
echo "   • Mailhog: http://localhost:8025"
echo "   • phpMyAdmin: http://localhost:8080"
echo "   • Xdebug: Porta 9003"
echo ""
echo "📁 Estrutura de projetos:"
echo "   • Coloque seus projetos PHP/Laravel em: ./projects/"
echo "   • Coloque seus projetos Node.js em: ./projects/"
echo ""
echo "🔧 Comandos úteis:"
echo "   • Parar ambiente: ./scripts/stop.sh"
echo "   • Ver logs: ./scripts/logs.sh"
echo "   • Acessar container: ./scripts/shell.sh [php|node|nginx]"
echo "   • Testar Xdebug: ./scripts/test-xdebug.sh"
echo ""
echo "📝 Para adicionar um novo projeto:"
echo "   1. Copie um template de nginx/conf.d/"
echo "   2. Configure o server_name e root"
echo "   3. Reinicie o nginx: docker-compose restart nginx"
