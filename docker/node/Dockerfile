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

# Criar usuário não-root
RUN addgroup -g 1000 nodeuser && \
    adduser -u 1000 -G nodeuser -s /bin/sh -D nodeuser

# Configurar diretório de trabalho
WORKDIR /var/www/projects

# Copiar arquivos de configuração
COPY package.json /var/www/projects/
COPY ecosystem.config.js /var/www/projects/

# Instalar dependências globais
RUN npm install -g \
    nodemon \
    typescript \
    ts-node \
    @types/node

# Definir permissões
RUN chown -R nodeuser:nodeuser /var/www/projects

# Mudar para usuário não-root
USER nodeuser

# Expor porta
EXPOSE 3000

# Comando padrão
CMD ["pm2-runtime", "ecosystem.config.js"]
