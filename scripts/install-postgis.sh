#!/bin/bash

# Script para instalar PostGIS no PostgreSQL
# Este script instala a extensão PostGIS no banco de dados PostgreSQL

set -e

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🗺️  Instalando PostGIS no PostgreSQL...${NC}"

# Verificar se o container está rodando
if ! docker-compose ps postgres | grep -q "Up"; then
    echo -e "${RED}❌ Container PostgreSQL não está rodando!${NC}"
    echo -e "${YELLOW}💡 Execute: docker-compose up -d postgres${NC}"
    exit 1
fi

# Obter o nome do banco de dados do .env ou usar o padrão
# Tenta ler do arquivo .env na raiz do projeto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -f "$PROJECT_ROOT/.env" ]; then
    source "$PROJECT_ROOT/.env"
fi

DB_NAME=${POSTGRES_DB:-devdb}
DB_USER=${POSTGRES_USER:-postgres}

echo -e "${BLUE}📋 Configuração:${NC}"
echo -e "   • Banco de dados: ${DB_NAME}"
echo -e "   • Usuário: ${DB_USER}"
echo ""

echo -e "${YELLOW}📦 Instalando pacotes PostGIS no container...${NC}"

# Instalar pacotes PostGIS no container
# Usa apt-get com flags para evitar prompts interativos
docker-compose exec -T postgres bash -c "
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -y -qq postgresql-15-postgis-3 postgresql-15-postgis-3-scripts 2>&1 | grep -v '^WARNING' || true
"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro ao instalar pacotes PostGIS${NC}"
    echo -e "${YELLOW}💡 Dica: Certifique-se de que o container tem permissões de root${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Pacotes PostGIS instalados!${NC}"
echo ""

echo -e "${YELLOW}🔧 Habilitando extensão PostGIS no banco de dados '${DB_NAME}'...${NC}"

# Habilitar extensão PostGIS no banco de dados
OUTPUT=$(docker-compose exec -T postgres psql -U "$DB_USER" -d "$DB_NAME" -c "CREATE EXTENSION IF NOT EXISTS postgis;" 2>&1)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ PostGIS habilitado com sucesso!${NC}"
    echo ""
    echo -e "${GREEN}📊 Verificando versão do PostGIS...${NC}"
    docker-compose exec -T postgres psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT PostGIS_version();" 2>&1 | grep -v "CREATE EXTENSION" | grep -v "NOTICE" || true
else
    echo -e "${RED}❌ Erro ao habilitar extensão PostGIS${NC}"
    echo -e "${YELLOW}Saída do erro:${NC}"
    echo "$OUTPUT"
    exit 1
fi

echo ""
echo -e "${GREEN}✨ Concluído! PostGIS está pronto para uso.${NC}"
echo ""
echo -e "${BLUE}💡 Dica: Se você precisar habilitar PostGIS em outros bancos de dados, execute:${NC}"
echo -e "   docker-compose exec postgres psql -U ${DB_USER} -d [nome_do_banco] -c 'CREATE EXTENSION IF NOT EXISTS postgis;'"

