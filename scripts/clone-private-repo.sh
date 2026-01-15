#!/bin/bash

# Script para clonar repositório privado via HTTPS
REPO_URL=$1
PROJECT_NAME=$2

if [ -z "$REPO_URL" ] || [ -z "$PROJECT_NAME" ]; then
    echo "❌ Uso: ./scripts/clone-private-repo.sh <url-do-repo> <nome-do-projeto>"
    echo ""
    echo "Exemplo:"
    echo "   ./scripts/clone-private-repo.sh https://github.com/AtrimDev/atrim.git atrim"
    echo ""
    echo "📝 Nota: Você precisará de um Personal Access Token do GitHub"
    echo "   Crie em: https://github.com/settings/tokens"
    echo "   Permissão necessária: repo (acesso completo a repositórios privados)"
    exit 1
fi

PROJECT_DIR="projects/$PROJECT_NAME"

echo "📥 Clonando repositório privado: $REPO_URL"
echo "📁 Diretório de destino: $PROJECT_DIR"
echo ""
echo "🔐 Quando solicitado:"
echo "   - Username: seu username do GitHub"
echo "   - Password: seu Personal Access Token (não sua senha!)"
echo ""

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
cd projects/
git clone "$REPO_URL" "$PROJECT_NAME"
CLONE_EXIT_CODE=$?
cd ..

if [ $CLONE_EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✅ Repositório clonado com sucesso!"
    echo ""
    echo "🔧 Deseja configurar automaticamente? (y/N)"
    read -p "   " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "⚙️  Configurando projeto..."
        ./scripts/setup-cloned-project.sh "$PROJECT_NAME" "$REPO_URL"
    else
        echo ""
        echo "📝 Para configurar depois, execute:"
        echo "   ./scripts/setup-cloned-project.sh $PROJECT_NAME $REPO_URL"
    fi
else
    echo ""
    echo "❌ Erro ao clonar repositório."
    echo ""
    echo "💡 Possíveis causas:"
    echo "   1. Repositório não encontrado ou sem acesso"
    echo "   2. Token inválido ou expirado"
    echo "   3. URL incorreta"
    echo ""
    echo "📖 Veja o guia: COMO-CLONAR-REPOSITORIO-PRIVADO.md"
    exit 1
fi





