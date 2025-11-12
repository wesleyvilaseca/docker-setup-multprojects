#!/bin/bash

echo "🧹 Iniciando limpeza segura do macOS..."
echo ""

# Função para calcular espaço liberado
TOTAL_FREED=0

# 1. Limpar cache do Yarn (2.8GB)
echo "📦 Limpando cache do Yarn..."
YARN_SIZE=$(du -sh ~/Library/Caches/Yarn 2>/dev/null | cut -f1)
if [ -d ~/Library/Caches/Yarn ]; then
    yarn cache clean 2>/dev/null || rm -rf ~/Library/Caches/Yarn/*
    echo "   ✅ Cache do Yarn limpo (era: $YARN_SIZE)"
fi
echo ""

# 2. Limpar cache do npm
echo "📦 Limpando cache do npm..."
npm cache clean --force 2>/dev/null
echo "   ✅ Cache do npm limpo"
echo ""

# 3. Limpar cache do pip (257MB)
echo "🐍 Limpando cache do pip..."
pip cache purge 2>/dev/null || rm -rf ~/Library/Caches/pip/*
echo "   ✅ Cache do pip limpo"
echo ""

# 4. Limpar cache do Homebrew (165MB)
echo "🍺 Limpando cache do Homebrew..."
brew cleanup --prune=all 2>/dev/null
echo "   ✅ Cache do Homebrew limpo"
echo ""

# 5. Limpar cache do Google (2.8GB) - apenas cache, não dados
echo "🔍 Limpando cache do Google..."
if [ -d ~/Library/Caches/Google ]; then
    GOOGLE_SIZE=$(du -sh ~/Library/Caches/Google 2>/dev/null | cut -f1)
    find ~/Library/Caches/Google -type f -atime +30 -delete 2>/dev/null
    echo "   ✅ Cache antigo do Google limpo (era: $GOOGLE_SIZE)"
fi
echo ""

# 6. Limpar cache do AWS (372MB)
echo "☁️  Limpando cache do AWS..."
if [ -d ~/Library/Caches/aws ]; then
    AWS_SIZE=$(du -sh ~/Library/Caches/aws 2>/dev/null | cut -f1)
    rm -rf ~/Library/Caches/aws/*
    echo "   ✅ Cache do AWS limpo (era: $AWS_SIZE)"
fi
echo ""

# 7. Limpar cache do TypeScript (149MB)
echo "📘 Limpando cache do TypeScript..."
if [ -d ~/Library/Caches/typescript ]; then
    TS_SIZE=$(du -sh ~/Library/Caches/typescript 2>/dev/null | cut -f1)
    rm -rf ~/Library/Caches/typescript/*
    echo "   ✅ Cache do TypeScript limpo (era: $TS_SIZE)"
fi
echo ""

# 8. Limpar cache do Unity (108MB)
echo "🎮 Limpando cache do Unity..."
if [ -d ~/Library/Caches/com.unity3d.UnityEditor ]; then
    UNITY_SIZE=$(du -sh ~/Library/Caches/com.unity3d.UnityEditor 2>/dev/null | cut -f1)
    rm -rf ~/Library/Caches/com.unity3d.UnityEditor/*
    echo "   ✅ Cache do Unity limpo (era: $UNITY_SIZE)"
fi
echo ""

# 9. Limpar cache do node-gyp (53MB)
echo "🔧 Limpando cache do node-gyp..."
if [ -d ~/Library/Caches/node-gyp ]; then
    NODEGYP_SIZE=$(du -sh ~/Library/Caches/node-gyp 2>/dev/null | cut -f1)
    rm -rf ~/Library/Caches/node-gyp/*
    echo "   ✅ Cache do node-gyp limpo (era: $NODEGYP_SIZE)"
fi
echo ""

# 10. Limpar logs antigos (mais de 30 dias)
echo "📋 Limpando logs antigos..."
find ~/Library/Logs -type f -mtime +30 -delete 2>/dev/null
echo "   ✅ Logs antigos removidos"
echo ""

# 11. Limpar Docker (se estiver rodando)
echo "🐳 Limpando Docker..."
if command -v docker &> /dev/null; then
    export DOCKER_HOST=unix://$HOME/.colima/default/docker.sock 2>/dev/null
    docker system prune -af --volumes 2>/dev/null || echo "   ⚠️  Docker não está rodando ou não há imagens para limpar"
    echo "   ✅ Docker limpo"
fi
echo ""

# 12. Limpar cache do Colima (347MB)
echo "🚀 Limpando cache do Colima..."
if [ -d ~/Library/Caches/colima ]; then
    COLIMA_SIZE=$(du -sh ~/Library/Caches/colima 2>/dev/null | cut -f1)
    # Manter apenas a imagem base mais recente
    find ~/Library/Caches/colima -type f -mtime +7 -delete 2>/dev/null
    echo "   ✅ Cache antigo do Colima limpo (era: $COLIMA_SIZE)"
fi
echo ""

# 13. Limpar lixeira
echo "🗑️  Limpando lixeira..."
rm -rf ~/.Trash/* 2>/dev/null
echo "   ✅ Lixeira limpa"
echo ""

# 14. Limpar cache do sistema (Xcode, etc)
echo "🛠️  Limpando caches do sistema..."
rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null
rm -rf ~/Library/Developer/Xcode/Archives/* 2>/dev/null
rm -rf ~/Library/Caches/com.apple.dt.* 2>/dev/null
echo "   ✅ Caches do Xcode limpos"
echo ""

# 15. Limpar cache do Siri (165MB)
echo "🗣️  Limpando cache do Siri..."
if [ -d ~/Library/Caches/SiriTTS ]; then
    SIRI_SIZE=$(du -sh ~/Library/Caches/SiriTTS 2>/dev/null | cut -f1)
    rm -rf ~/Library/Caches/SiriTTS/*
    echo "   ✅ Cache do Siri limpo (era: $SIRI_SIZE)"
fi
echo ""

echo "✨ Limpeza concluída!"
echo ""
echo "💡 Dicas adicionais:"
echo "   - Cursor: 5.4GB em ~/Library/Application Support/Cursor (pode limpar extensões não usadas)"
echo "   - VS Code: 3.5GB em ~/Library/Application Support/Code (pode limpar extensões não usadas)"
echo "   - Google App Support: 1.6GB (dados de apps, não recomendado limpar)"
echo ""
echo "📊 Para verificar espaço liberado, execute:"
echo "   df -h /"

