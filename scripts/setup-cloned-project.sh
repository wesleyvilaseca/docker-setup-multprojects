#!/bin/bash

# Script para configurar projeto Python clonado
PROJECT_NAME=$1
REPO_URL=$2

if [ -z "$PROJECT_NAME" ] || [ -z "$REPO_URL" ]; then
    echo "❌ Uso: ./scripts/setup-cloned-project.sh <nome-do-projeto> <url-do-repo>"
    echo ""
    echo "Exemplos:"
    echo "   ./scripts/setup-cloned-project.sh meu-django https://github.com/usuario/meu-django.git"
    echo "   ./scripts/setup-cloned-project.sh minha-api https://gitlab.com/usuario/minha-api.git"
    exit 1
fi

PROJECT_DIR="projects/$PROJECT_NAME"
NGINX_CONFIG="nginx/conf.d/$PROJECT_NAME.conf"

echo "📁 Configurando projeto clonado: $PROJECT_NAME"

# Verificar se o diretório já existe
if [ -d "$PROJECT_DIR" ]; then
    echo "⚠️  Diretório $PROJECT_DIR já existe."
    read -p "Deseja continuar? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Clonar o repositório
echo "📥 Clonando repositório..."
cd projects/
git clone "$REPO_URL" "$PROJECT_NAME"
cd ..

# Configurar nginx
echo "🌐 Configurando nginx..."
cp nginx/conf.d/python-projects.conf "$NGINX_CONFIG"
sed -i.bak "s/django-app/$PROJECT_NAME/g" "$NGINX_CONFIG"
rm "$NGINX_CONFIG.bak"

# Instalar dependências Python (se requirements.txt existir)
if [ -f "$PROJECT_DIR/requirements.txt" ]; then
    echo "📦 Instalando dependências Python..."
    docker-compose exec python bash -c "cd $PROJECT_NAME && pip install -r requirements.txt"
fi

# Instalar dependências Node.js (se package.json existir)
if [ -f "$PROJECT_DIR/package.json" ]; then
    echo "📦 Instalando dependências Node.js..."
    docker-compose exec node bash -c "cd $PROJECT_NAME && npm install"
fi

echo ""
echo "✅ Projeto $PROJECT_NAME configurado com sucesso!"
echo ""
echo "🔧 Próximos passos:"
echo "   1. Reinicie o nginx: docker-compose restart nginx"
echo "   2. Adicione ao /etc/hosts: echo '127.0.0.1 $PROJECT_NAME.localhost' | sudo tee -a /etc/hosts"
echo "   3. Acesse: http://$PROJECT_NAME.localhost"
echo ""
echo "🐍 Para projetos Python:"
echo "   ./scripts/python-shell.sh"
echo "   cd $PROJECT_NAME"
echo "   python manage.py runserver 0.0.0.0:8000  # Django"
echo "   python app.py                              # Flask"
echo "   uvicorn main:app --host 0.0.0.0 --port 8000 --reload  # FastAPI"
