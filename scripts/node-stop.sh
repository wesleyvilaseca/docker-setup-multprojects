#!/bin/bash

# Script para parar todos os processos Node.js rodando no container
# Uso: ./scripts/node-stop.sh

echo "🛑 Parando todos os processos Node.js..."

# Verificar se container está rodando
if ! docker compose ps node | grep -q "Up"; then
    echo "⚠️  Container Node.js não está rodando."
    exit 0
fi

# Contar processos Node.js rodando
NODE_PROCESSES=$(docker compose exec node sh -c "ps aux | grep -E 'node|npm|vite|nodemon' | grep -v grep | wc -l" 2>/dev/null | tr -d ' ')

if [ "$NODE_PROCESSES" = "0" ] || [ -z "$NODE_PROCESSES" ]; then
    echo "✅ Nenhum processo Node.js encontrado rodando."
    exit 0
fi

echo "📊 Encontrados $NODE_PROCESSES processo(s) Node.js rodando."
echo ""

# Mostrar processos rodando
echo "📋 Processos Node.js ativos:"
docker compose exec node sh -c "ps aux | grep -E 'node|npm|vite|nodemon' | grep -v grep" 2>/dev/null || true
echo ""

# Parar todos os processos Node.js
echo "🔪 Parando processos..."

# Matar processos node (incluindo npm, vite, nodemon)
docker compose exec node sh -c "pkill -f 'node|npm|vite|nodemon' || true" 2>/dev/null

# Aguardar um pouco para processos finalizarem
sleep 2

# Verificar se ainda há processos rodando
REMAINING=$(docker compose exec node sh -c "ps aux | grep -E 'node|npm|vite|nodemon' | grep -v grep | wc -l" 2>/dev/null | tr -d ' ')

if [ "$REMAINING" = "0" ] || [ -z "$REMAINING" ]; then
    echo "✅ Todos os processos Node.js foram parados com sucesso!"
else
    echo "⚠️  Ainda há $REMAINING processo(s) rodando."
    echo "💡 Se necessário, execute novamente: ./scripts/node-stop.sh"
    echo "💡 Ou force parada: docker compose exec node sh -c 'pkill -9 -f node'"
fi

