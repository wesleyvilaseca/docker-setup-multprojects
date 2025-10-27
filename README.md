# 🐳 Docker Developer Setup

Um ambiente Docker completo para desenvolvimento multi-projetos com suporte a PHP/Laravel e Node.js.

## 🚀 Características

- **PHP 8.3** com Laravel, extensões MongoDB, Redis e Xdebug
- **Node.js 20** com PM2 para gerenciamento de processos
- **Nginx** como proxy reverso com suporte a vhosts
- **MongoDB** para banco de dados
- **Redis** para cache e sessões
- **Mailhog** para desenvolvimento de emails
- **phpMyAdmin** para gerenciamento de banco (opcional)

## 📁 Estrutura do Projeto

```
docker-developer-setup/
├── docker/
│   ├── php/
│   │   ├── Dockerfile
│   │   └── php.ini
│   ├── node/
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── ecosystem.config.js
│   └── mongodb/
│       └── mongod.conf
├── nginx/
│   ├── nginx.conf
│   └── conf.d/
│       ├── default.conf          # ✅ Versionado
│       ├── php-projects.conf     # ✅ Versionado (template)
│       ├── node-projects.conf    # ✅ Versionado (template)
│       └── *.conf               # ❌ Não versionado (vhosts específicos)
├── projects/          # Seus projetos aqui
├── scripts/
│   ├── start.sh
│   ├── stop.sh
│   ├── logs.sh
│   ├── shell.sh
│   └── add-project.sh
└── docker-compose.yml
```

### 📝 Sobre Versionamento

- **✅ Versionados**: Templates e configurações base
- **❌ Não versionados**: Vhosts específicos de projetos, logs, SSL certificates
- **🤔 Opcional**: Pasta `projects/` (configure no `.gitignore` conforme necessário)

## 🛠️ Como Usar

### 1. Iniciar o Ambiente

```bash
./scripts/start.sh
```

### 2. Parar o Ambiente

```bash
./scripts/stop.sh
```

### 3. Ver Logs

```bash
# Todos os logs
./scripts/logs.sh

# Logs específicos
./scripts/logs.sh nginx
./scripts/logs.sh php
./scripts/logs.sh node
```

### 4. Acessar Containers

```bash
# Shell do PHP
./scripts/shell.sh php

# Shell do Node.js
./scripts/shell.sh node

# Shell do Nginx
./scripts/shell.sh nginx

# MongoDB shell
./scripts/shell.sh mongodb

# Redis CLI
./scripts/shell.sh redis
```

### 5. Testar Xdebug

```bash
# Testar configuração do Xdebug
./scripts/test-xdebug.sh
```

## 📦 Adicionando Novos Projetos

### Projeto PHP/Laravel

```bash
./scripts/add-project.sh meu-laravel-app php
```

### Projeto Node.js

```bash
./scripts/add-project.sh minha-api-node node
```

## 🌐 Configuração de VHosts

### Para Projetos PHP/Laravel

1. Use o script: `./scripts/add-project.sh meu-projeto php`
2. Ou copie manualmente: `cp nginx/conf.d/php-projects.conf nginx/conf.d/meu-projeto.conf`
3. Edite o arquivo e configure:
   - `server_name`: domínio do projeto
   - `root`: caminho para o diretório public do Laravel
4. Reinicie o nginx: `docker-compose restart nginx`

### Para Projetos Node.js

1. Use o script: `./scripts/add-project.sh meu-projeto node`
2. Ou copie manualmente: `cp nginx/conf.d/node-projects.conf nginx/conf.d/meu-projeto.conf`
3. Edite o arquivo e configure:
   - `server_name`: domínio do projeto
   - `proxy_pass`: porta do seu app Node.js
4. Reinicie o nginx: `docker-compose restart nginx`

## 🔧 Configuração do /etc/hosts

Adicione os domínios dos seus projetos ao arquivo `/etc/hosts`:

```
127.0.0.1 meu-laravel-app.localhost
127.0.0.1 minha-api-node.localhost
127.0.0.1 projeto-php.localhost
127.0.0.1 projeto-node.localhost
```

## 🌍 URLs de Acesso

- **Nginx**: http://localhost
- **Mailhog**: http://localhost:8025
- **phpMyAdmin**: http://localhost:8080
- **Xdebug**: Porta 9003
- **Seus projetos**: http://[nome-do-projeto].localhost

## 🐛 Configuração do Xdebug

### Configuração Automática

O Xdebug já está configurado e funcionando! As configurações incluem:

- **Porta**: 9003
- **IDE Key**: PHPSTORM
- **Host**: host.docker.internal
- **Modo**: debug automático

### Para VS Code

1. Instale a extensão "PHP Debug"
2. A configuração já está pronta em `.vscode/launch.json`
3. Coloque breakpoints e inicie o debug

### Para PhpStorm

1. Vá em `File > Settings > PHP > Debug`
2. Configure:
   - **Xdebug port**: 9003
   - **IDE key**: PHPSTORM
3. Ative "Start listening for PHP Debug connections"

### Testar Xdebug

```bash
# Executar teste
./scripts/test-xdebug.sh

# Acessar arquivo de teste
http://localhost/xdebug-test.php
```

### Configurações Avançadas

Edite `docker/php/xdebug.ini` para customizar:

```ini
; Mudar IDE Key
xdebug.idekey=VSCODE

; Ativar profiling
xdebug.mode=debug,profile

; Configurar log level
xdebug.log_level=1
```

## 🗄️ Conexões de Banco

### MongoDB

- **Host**: localhost
- **Porta**: 27017
- **Usuário**: root
- **Senha**: rootpassword

### Redis

- **Host**: localhost
- **Porta**: 6379

## 📝 Exemplos de Uso

### Laravel

```bash
# Criar projeto Laravel
./scripts/add-project.sh meu-laravel php
cd projects/meu-laravel
composer create-project laravel/laravel .
```

### Node.js

```bash
# Criar projeto Node.js
./scripts/add-project.sh minha-api node
cd projects/minha-api
npm install express cors helmet morgan
```

## 🔍 Troubleshooting

### Container não inicia

```bash
# Ver logs específicos
docker-compose logs [nome-do-container]

# Reconstruir containers
docker-compose up -d --build --force-recreate
```

### Nginx não carrega configuração

```bash
# Testar configuração
docker-compose exec nginx nginx -t

# Recarregar configuração
docker-compose exec nginx nginx -s reload
```

### Permissões de arquivo

```bash
# Corrigir permissões
sudo chown -R $USER:$USER projects/
```

## 🚀 Comandos Úteis

```bash
# Ver status dos containers
docker-compose ps

# Reiniciar um serviço específico
docker-compose restart nginx

# Parar e remover volumes
docker-compose down -v

# Limpar containers e imagens
docker system prune -a
```

## 📚 Recursos Adicionais

- [Documentação do Docker Compose](https://docs.docker.com/compose/)
- [Documentação do Nginx](https://nginx.org/en/docs/)
- [Documentação do Laravel](https://laravel.com/docs)
- [Documentação do Node.js](https://nodejs.org/docs/)
