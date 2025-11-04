FROM node:20-alpine

# Instalar dependências do sistema
RUN apk add --no-cache \
    git \
    curl \
    bash \
    make \
    g++ \
    python3 \
    py3-pip

# Instalar PM2 globalmente para gerenciamento de processos
RUN npm install -g pm2

# Configurar diretório de trabalho
WORKDIR /var/www/projects

# Instalar dependências globais
RUN npm install -g \
    nodemon \
    typescript \
    ts-node \
    @types/node

# Criar diretório e definir permissões (usando usuário node que já existe na imagem)
RUN mkdir -p /var/www/projects && \
    chown -R node:node /var/www/projects

# Mudar para usuário não-root (node já existe na imagem oficial)
USER node

# Expor porta
EXPOSE 3000

# Comando padrão (manter container vivo para desenvolvimento)
# Usando tail -f /dev/null que funciona melhor com usuário não-root
CMD ["sh", "-c", "tail -f /dev/null"]
