#!/bin/bash

# Script para iniciar servidor de desenvolvimento Node.js/Vue.js dentro do container
# Uso: ./scripts/node-dev.sh [caminho-do-projeto] [porta]
#
# Exemplos:
#   ./scripts/node-dev.sh dashboard-prefeituras-frontend
#   ./scripts/node-dev.sh atrim-projects/dashboard-prefeituras-frontend
#   ./scripts/node-dev.sh projects/atrim-projects/dashboard-prefeituras-frontend
#   ./scripts/node-dev.sh dashboard-prefeituras-frontend 3000

PROJECT_PATH_INPUT=$1
PORT=${2:-3000}

# Função para listar projetos Node.js disponíveis
list_node_projects() {
    echo "📋 Projetos Node.js/Vue.js encontrados:"
    echo ""
    local count=0
    # Buscar package.json excluindo node_modules e vendor
    find projects/ -name "package.json" -type f -not -path "*/node_modules/*" -not -path "*/vendor/*" 2>/dev/null | while read -r pkg; do
        project_dir=$(dirname "$pkg")
        project_path=${project_dir#projects/}
        echo "   • $project_path"
        count=$((count + 1))
    done
    echo ""
    if [ $count -eq 0 ]; then
        echo "⚠️  Nenhum projeto Node.js encontrado em projects/"
    fi
    echo "💡 Use: ./scripts/node-dev.sh <caminho-do-projeto>"
    echo "   Exemplo: ./scripts/node-dev.sh atrim-projects/dashboard-prefeituras-frontend"
    echo "   Exemplo: ./scripts/node-dev.sh dashboard-prefeituras-frontend"
}

# Se não especificou projeto, listar projetos disponíveis
if [ -z "$PROJECT_PATH_INPUT" ]; then
    echo "❌ Nenhum projeto especificado."
    echo ""
    list_node_projects
    exit 1
fi

# Função para encontrar o projeto
find_project() {
    local search_path=$1
    
    # Se já é um caminho completo dentro de projects/, usar diretamente
    if [[ "$search_path" == projects/* ]]; then
        PROJECT_PATH="/var/www/projects/${search_path#projects/}"
        return 0
    fi
    
    # Se é um caminho relativo (ex: atrim-projects/dashboard-prefeituras-frontend)
    if [[ "$search_path" == */* ]]; then
        PROJECT_PATH="/var/www/projects/$search_path"
        return 0
    fi
    
    # Se é apenas o nome do projeto, buscar recursivamente em projects/
    # Excluir node_modules e vendor
    # Primeiro, tentar encontrar um diretório com esse nome que contenha package.json
    local found=$(find projects/ -type d -name "$search_path" -not -path "*/node_modules/*" -not -path "*/vendor/*" -exec test -f {}/package.json \; -print | head -1)
    if [ -n "$found" ]; then
        found_path=${found#projects/}
        PROJECT_PATH="/var/www/projects/$found_path"
        return 0
    fi
    
    # Se não encontrou, buscar qualquer package.json com nome do projeto no caminho
    local found_pkg=$(find projects/ -name "package.json" -not -path "*/node_modules/*" -not -path "*/vendor/*" \( -path "*/$search_path/*" -o -path "*/$search_path/package.json" \) | head -1)
    if [ -n "$found_pkg" ]; then
        found_path=$(dirname "$found_pkg")
        found_path=${found_path#projects/}
        PROJECT_PATH="/var/www/projects/$found_path"
        return 0
    fi
    
    return 1
}

# Encontrar o projeto
if ! find_project "$PROJECT_PATH_INPUT"; then
    echo "❌ Projeto não encontrado: $PROJECT_PATH_INPUT"
    echo ""
    list_node_projects
    exit 1
fi

# Extrair nome do projeto para exibição
PROJECT_NAME=$(basename "$PROJECT_PATH")

echo "🚀 Iniciando servidor de desenvolvimento"
echo "📁 Projeto: $PROJECT_NAME"
echo "📂 Caminho: $PROJECT_PATH"
echo "🔌 Porta: $PORT"
echo ""

# Verificar se container está rodando
if ! docker compose ps node | grep -q "Up"; then
    echo "❌ Container Node.js não está rodando. Execute: ./scripts/start.sh"
    exit 1
fi

# Verificar se projeto existe
if ! docker compose exec node test -d "$PROJECT_PATH"; then
    echo "❌ Projeto não encontrado em: $PROJECT_PATH"
    echo "   Verifique se o projeto existe em: projects/${PROJECT_PATH#/var/www/projects/}"
    exit 1
fi

# Verificar se é um projeto Node.js (tem package.json)
if ! docker compose exec node test -f "$PROJECT_PATH/package.json"; then
    echo "❌ Não é um projeto Node.js (package.json não encontrado)"
    echo "   Caminho verificado: $PROJECT_PATH"
    exit 1
fi

# Verificar se node_modules existe, se não, instalar
if ! docker compose exec node test -d "$PROJECT_PATH/node_modules"; then
    echo "📦 Instalando dependências..."
    docker compose exec node bash -c "cd $PROJECT_PATH && npm install"
    if [ $? -ne 0 ]; then
        echo "❌ Falha ao instalar dependências."
        exit 1
    fi
fi

echo "✅ Iniciando servidor de desenvolvimento..."
echo "🌐 Acesse em: http://atrim.dashboard.site (ou o domínio configurado no Nginx)"
echo "💡 Para parar, pressione Ctrl+C"
echo ""

# Iniciar servidor de desenvolvimento
docker compose exec -T node bash -c "cd $PROJECT_PATH && npm run dev"
