#!/bin/bash

# Script para adicionar um novo projeto
PROJECT_NAME=$1
PROJECT_TYPE=$2

if [ -z "$PROJECT_NAME" ] || [ -z "$PROJECT_TYPE" ]; then
    echo "❌ Uso: ./scripts/add-project.sh [nome-do-projeto] [php|node]"
    echo ""
    echo "Exemplos:"
    echo "   ./scripts/add-project.sh meu-laravel-app php"
    echo "   ./scripts/add-project.sh minha-api-node node"
    exit 1
fi

PROJECT_DIR="projects/$PROJECT_NAME"
NGINX_CONFIG="nginx/conf.d/$PROJECT_NAME.conf"

echo "📁 Criando projeto: $PROJECT_NAME ($PROJECT_TYPE)"

# Criar diretório do projeto
mkdir -p "$PROJECT_DIR"

if [ "$PROJECT_TYPE" = "php" ]; then
    echo "🐘 Configurando projeto PHP/Laravel..."
    
    # Copiar template de configuração nginx
    cp nginx/conf.d/php-projects.conf "$NGINX_CONFIG"
    
    # Substituir variáveis no template
    sed -i.bak "s/laravel-app/$PROJECT_NAME/g" "$NGINX_CONFIG"
    sed -i.bak "s/laravel-app/$PROJECT_NAME/g" "$NGINX_CONFIG"
    rm "$NGINX_CONFIG.bak"
    
    echo "✅ Projeto PHP criado em: $PROJECT_DIR"
    echo "📝 Configure o server_name em: $NGINX_CONFIG"
    
elif [ "$PROJECT_TYPE" = "node" ]; then
    echo "🟢 Configurando projeto Node.js..."
    
    # Copiar template de configuração nginx
    cp nginx/conf.d/node-projects.conf "$NGINX_CONFIG"
    
    # Substituir variáveis no template
    sed -i.bak "s/node-api/$PROJECT_NAME/g" "$NGINX_CONFIG"
    rm "$NGINX_CONFIG.bak"
    
    # Criar package.json básico
    cat > "$PROJECT_DIR/package.json" << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF
    
    # Criar index.js básico
    cat > "$PROJECT_DIR/index.js" << EOF
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.json({ 
        message: 'Hello from $PROJECT_NAME!',
        timestamp: new Date().toISOString()
    });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(\`Server running on port \${PORT}\`);
});
EOF
    
    echo "✅ Projeto Node.js criado em: $PROJECT_DIR"
    echo "📝 Configure o server_name em: $NGINX_CONFIG"
    
else
    echo "❌ Tipo de projeto inválido: $PROJECT_TYPE"
    echo "Tipos suportados: php, node"
    exit 1
fi

echo ""
echo "🔧 Próximos passos:"
echo "   1. Configure o server_name em: $NGINX_CONFIG"
echo "   2. Reinicie o nginx: docker-compose restart nginx"
echo "   3. Adicione o domínio ao /etc/hosts (ex: 127.0.0.1 $PROJECT_NAME.localhost)"
echo "   4. Desenvolva seu projeto em: $PROJECT_DIR"
