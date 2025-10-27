#!/bin/bash

# Script para testar configuração do Xdebug
echo "🔍 Testando configuração do Xdebug..."

# Verificar se o container PHP está rodando
if ! docker-compose ps php | grep -q "Up"; then
    echo "❌ Container PHP não está rodando. Execute: ./scripts/start.sh"
    exit 1
fi

echo "📋 Informações do Xdebug:"
echo ""

# Verificar se Xdebug está instalado
echo "🔧 Verificando instalação do Xdebug..."
docker-compose exec php php -m | grep -i xdebug
if [ $? -eq 0 ]; then
    echo "✅ Xdebug está instalado"
else
    echo "❌ Xdebug não está instalado"
    exit 1
fi

echo ""

# Mostrar configurações do Xdebug
echo "⚙️ Configurações do Xdebug:"
docker-compose exec php php -i | grep -E "xdebug\.(mode|client_host|client_port|idekey)"

echo ""

# Testar conexão
echo "🌐 Testando conectividade..."
echo "   • Host: host.docker.internal"
echo "   • Porta: 9003"
echo "   • IDE Key: PHPSTORM"

echo ""

# Criar arquivo de teste
echo "📝 Criando arquivo de teste..."
cat > projects/xdebug-test.php << 'EOF'
<?php
// Arquivo de teste para Xdebug
echo "Testando Xdebug...\n";

// Coloque um breakpoint aqui
$variavel = "Hello Xdebug!";
echo $variavel . "\n";

// Função para testar stepping
function testarXdebug($parametro) {
    $resultado = $parametro * 2;
    return $resultado;
}

$numero = 42;
$resultado = testarXdebug($numero);
echo "Resultado: " . $resultado . "\n";

echo "✅ Teste concluído!\n";
?>
EOF

echo "✅ Arquivo de teste criado em: projects/xdebug-test.php"
echo ""
echo "🔧 Para testar o Xdebug:"
echo "   1. Configure seu IDE para escutar na porta 9003"
echo "   2. Acesse: http://localhost/xdebug-test.php"
echo "   3. Coloque breakpoints no código"
echo "   4. O debug deve funcionar automaticamente"
echo ""
echo "📚 Configurações para IDEs:"
echo "   • VS Code: Instale a extensão 'PHP Debug'"
echo "   • PhpStorm: Configure 'PHP | Debug' nas configurações"
echo "   • Porta: 9003"
echo "   • IDE Key: PHPSTORM"
