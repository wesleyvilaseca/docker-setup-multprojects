# 🐳 Docker Developer Setup

Um ambiente Docker completo para desenvolvimento multi-projetos com suporte a PHP/Laravel, Node.js e Python.

## 🚀 Características

- **PHP 8.3** com Laravel, extensões MongoDB, Redis e Xdebug
- **Node.js 20** com PM2 para gerenciamento de processos
- **Python 3.11** com Django, Flask, FastAPI e dependências essenciais
- **Nginx** como proxy reverso com suporte a vhosts
- **MongoDB** para banco de dados NoSQL
- **PostgreSQL 15** para banco de dados relacional com configurações anti-deadlock
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
│   ├── python/
│   │   └── Dockerfile
│   ├── mongodb/
│   │   └── mongod.conf
│   └── postgres/
│       └── postgresql.conf
├── nginx/
│   ├── nginx.conf
│   └── conf.d/
│       ├── default.conf          # ✅ Versionado
│       ├── php-projects.conf     # ✅ Versionado (template)
│       ├── node-projects.conf    # ✅ Versionado (template)
│       ├── python-projects.conf  # ✅ Versionado (template)
│       └── *.conf               # ❌ Não versionado (vhosts específicos)
├── projects/          # Seus projetos aqui
├── scripts/
│   ├── start.sh
│   ├── stop.sh
│   ├── logs.sh
│   ├── shell.sh
│   ├── add-project.sh
│   ├── python-shell.sh
│   ├── python-install.sh
│   └── setup-cloned-project.sh
└── docker-compose.yml
```

### 📝 Sobre Versionamento

- **✅ Versionados**: Templates e configurações base
- **❌ Não versionados**: Vhosts específicos de projetos, logs, SSL certificates
- **🤔 Opcional**: Pasta `projects/` (configure no `.gitignore` conforme necessário)

## 🛠️ Como Usar

### 1. Iniciar o Ambiente

#### ✅ Usando Script (Recomendado):

```bash
./scripts/start.sh
```

**O que o script faz:**

- ✅ Verifica se Docker está rodando
- ✅ Cria diretórios necessários (`projects/`, `ssl/`, `logs/`)
- ✅ Constrói e inicia containers com `docker-compose up -d --build`
- ✅ Aguarda containers iniciarem
- ✅ Mostra status e informações úteis

#### 🔧 Usando Docker Compose Diretamente:

```bash
docker-compose up -d --build
```

**Funciona perfeitamente!** Mas você precisará:

- Criar diretórios manualmente (se não existirem)
- Verificar status manualmente: `docker-compose ps`
- Lembrar comandos úteis

### 2. Parar o Ambiente

#### ✅ Usando Script:

```bash
./scripts/stop.sh
```

#### 🔧 Usando Docker Compose Diretamente:

```bash
docker-compose down
```

**Ambos funcionam igualmente!** O script apenas adiciona mensagens informativas.

### 📋 Comparação: Scripts vs Docker Compose Direto

| Ação          | Script                             | Docker Compose                     | Funciona Igual?                    |
| ------------- | ---------------------------------- | ---------------------------------- | ---------------------------------- |
| **Iniciar**   | `./scripts/start.sh`               | `docker-compose up -d --build`     | ✅ Sim, mas script cria diretórios |
| **Parar**     | `./scripts/stop.sh`                | `docker-compose down`              | ✅ Sim, idêntico                   |
| **Ver logs**  | `./scripts/logs.sh`                | `docker-compose logs`              | ✅ Sim, idêntico                   |
| **Status**    | Incluído no start.sh               | `docker-compose ps`                | ✅ Sim, idêntico                   |
| **Reiniciar** | `docker-compose restart [serviço]` | `docker-compose restart [serviço]` | ✅ Sim, idêntico                   |

**💡 Recomendação:**

- **Primeira vez ou setup**: Use `./scripts/start.sh` (cria diretórios automaticamente)
- **Uso diário**: Você pode usar `docker-compose up -d` diretamente sem problemas
- **Desenvolvimento**: Use o que preferir, ambos funcionam perfeitamente!

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

# Shell do Python
./scripts/python-shell.sh

# Shell do Nginx
./scripts/shell.sh nginx

# MongoDB shell
./scripts/shell.sh mongodb

# Redis CLI
./scripts/shell.sh redis

# PostgreSQL shell
docker-compose exec postgres psql -U postgres -d devdb
```

### 5. Testar Xdebug

```bash
# Testar configuração do Xdebug
./scripts/test-xdebug.sh
```

### 6. Scripts Disponíveis

```bash
# Gerenciamento de projetos
./scripts/add-project.sh [nome] [php|node|python]     # Criar projeto novo
./scripts/setup-cloned-project.sh [nome] [url-repo]   # Configurar projeto clonado

# Acesso aos containers
./scripts/shell.sh [php|node|nginx]                    # Shell PHP/Node/Nginx
./scripts/python-shell.sh                             # Shell Python

# Instalação de pacotes
./scripts/python-install.sh [projeto] [pacote]        # Instalar pacote Python
```

## 📦 Adicionando Novos Projetos

### 🆕 Criando Projeto Novo (Do Zero)

Use o script para criar projetos com templates básicos:

#### Projeto PHP/Laravel

```bash
./scripts/add-project.sh meu-laravel-app php
```

#### Projeto Node.js

```bash
./scripts/add-project.sh minha-api-node node
```

#### Projeto Python

```bash
./scripts/add-project.sh meu-django-app python
```

### 📥 Clonando Projeto Existente (GitHub/GitLab)

Para trabalhar com projetos já existentes:

#### Método Manual:

```bash
# 1. Clone o repositório
cd projects/
git clone https://github.com/usuario/meu-projeto.git

# 2. Configure o vhost
cp nginx/conf.d/python-projects.conf nginx/conf.d/meu-projeto.conf

# 3. Edite a configuração
# Editar nginx/conf.d/meu-projeto.conf
# server_name meu-projeto.localhost;

# 4. Reinicie o nginx
docker-compose restart nginx

# 5. Adicione ao /etc/hosts
echo "127.0.0.1 meu-projeto.localhost" | sudo tee -a /etc/hosts
```

#### Método Automatizado (Script):

```bash
# Configure automaticamente um projeto clonado
./scripts/setup-cloned-project.sh meu-projeto https://github.com/usuario/meu-projeto.git
```

### 🤔 Quando Usar Cada Método?

#### ✅ Use `add-project.sh` quando:

- Criar um projeto **do zero**
- Quiser templates básicos (Flask, FastAPI, Express)
- For um projeto simples ou MVP
- Quiser configuração automática completa

#### ✅ Use `setup-cloned-project.sh` quando:

- Trabalhar com projetos **já existentes**
- Clonar do GitHub/GitLab/Bitbucket
- Projeto com estrutura complexa
- Quiser manter histórico Git

#### ✅ Use método manual quando:

- Precisar de configuração específica
- Quiser entender cada passo
- Projeto com requisitos especiais

### 🔧 Configuração de VHosts

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

### Para Projetos Python

1. Use o script: `./scripts/add-project.sh meu-projeto python`
2. Ou copie manualmente: `cp nginx/conf.d/python-projects.conf nginx/conf.d/meu-projeto.conf`
3. Edite o arquivo e configure:
   - `server_name`: domínio do projeto
   - `proxy_pass`: porta do seu app Python (padrão: 8000)
4. Reinicie o nginx: `docker-compose restart nginx`

## 🔧 Configuração do /etc/hosts

Adicione os domínios dos seus projetos ao arquivo `/etc/hosts`:

```
127.0.0.1 meu-laravel-app.localhost
127.0.0.1 minha-api-node.localhost
127.0.0.1 meu-django-app.localhost
127.0.0.1 projeto-php.localhost
127.0.0.1 projeto-node.localhost
127.0.0.1 projeto-python.localhost
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

### PostgreSQL

- **Host**: localhost
- **Porta**: 5432
- **Usuário**: postgres (ou `POSTGRES_USER` do .env)
- **Senha**: postgres (ou `POSTGRES_PASSWORD` do .env)
- **Database**: devdb (ou `POSTGRES_DB` do .env)

**Variáveis de ambiente (opcional):**

```bash
# Criar arquivo .env na raiz do projeto
POSTGRES_DB=meudb
POSTGRES_USER=meuuser
POSTGRES_PASSWORD=minhasenha
```

**Configurações anti-deadlock incluídas:**

As configurações anti-deadlock são aplicadas automaticamente na primeira inicialização do PostgreSQL através do script `docker/postgres/01-init-config.sql`.

**Para aplicar em um banco existente:**

```bash
# Aplicar configurações manualmente em um banco já existente
docker-compose exec postgres psql -U postgres -d devdb -f /docker-entrypoint-initdb.d/01-init-config.sql

# Ou aplicar via SQL direto
docker-compose exec postgres psql -U postgres -d devdb -c "ALTER SYSTEM SET deadlock_timeout = '5s';"
docker-compose exec postgres psql -U postgres -d devdb -c "SELECT pg_reload_conf();"
```

**Configurações principais:**

- `deadlock_timeout = 5s` (aumentado de 1s)
- `log_deadlocks = on` (log de deadlocks)
- `lock_timeout = 30s` (timeout para locks)
- `statement_timeout = 300s` (timeout para statements)
- `max_connections = 200` (mais conexões)
- `shared_buffers = 256MB` (memória compartilhada)
- `work_mem = 4MB` (memória por operação)

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

### Python

#### Django

```bash
# Criar projeto Django
./scripts/add-project.sh meu-django python
cd projects/meu-django
./scripts/python-shell.sh
django-admin startproject myproject .
python manage.py runserver 0.0.0.0:8000
```

#### Flask

```bash
# Criar projeto Flask
./scripts/add-project.sh minha-api-flask python
cd projects/minha-api-flask
./scripts/python-shell.sh
python app.py
```

#### FastAPI

```bash
# Criar projeto FastAPI
./scripts/add-project.sh minha-api-fastapi python
cd projects/minha-api-fastapi
./scripts/python-shell.sh
python main.py
# ou
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

## ⚠️ Prevenção de Deadlocks

### ❌ **NÃO Use `TARGETPLATFORM=linux/amd64` em Mac Apple Silicon!**

**Por que NÃO usar:**

- Forçar `platform: linux/amd64` em Mac com Apple Silicon (M1/M2/M3) **causa deadlocks**
- Emulação é **10-20x mais lenta** que execução nativa
- Processos ficam "presos" esperando recursos
- Bancos de dados não conseguem processar queries a tempo
- Timeouts em cascata entre serviços

**✅ O que fazer:**

- **Deixe o Docker escolher automaticamente** a melhor arquitetura
- O ambiente já está configurado para evitar deadlocks sem forçar plataforma

### 🛡️ **Configurações Anti-Deadlock Incluídas:**

1. **Health Checks**: Todos os serviços têm health checks configurados
2. **Restart Policies**: `restart: unless-stopped` para recuperação automática
3. **Redis Timeouts**: Configurado com `--timeout 300` e `--tcp-keepalive 60`
4. **Dependências**: Serviços aguardam dependências iniciarem corretamente

### 🔧 **Se Você Estiver em Mac Intel (x86_64):**

Se você estiver usando Mac Intel (não Apple Silicon), pode usar `platform` normalmente:

```yaml
# Apenas para Mac Intel ou Linux
platform: linux/amd64
```

Mas **não é necessário** - o Docker detecta automaticamente.

### 📊 **Monitorando Deadlocks:**

```bash
# Ver logs de todos os serviços
./scripts/logs.sh

# Ver logs específicos
docker-compose logs mongodb
docker-compose logs redis
docker-compose logs postgres

# Verificar deadlocks no PostgreSQL
docker-compose exec postgres psql -U postgres -d devdb -c "
SELECT
    pid,
    now() - pg_stat_activity.query_start AS duration,
    query,
    state,
    wait_event_type,
    wait_event
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > interval '5 seconds'
ORDER BY duration DESC;
"

# Verificar status dos containers
docker-compose ps

# Verificar recursos
docker stats
```

## 🔍 Troubleshooting

### Container não inicia

```bash
# Ver logs específicos
docker-compose logs [nome-do-container]

# Reconstruir containers
docker-compose up -d --build --force-recreate

# Instalar pacote Python
./scripts/python-install.sh meu-projeto django
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

# Acessar containers
./scripts/shell.sh php
./scripts/shell.sh node
./scripts/python-shell.sh

# Instalar pacotes Python
./scripts/python-install.sh meu-projeto django

# Configurar projeto clonado
./scripts/setup-cloned-project.sh meu-projeto https://github.com/usuario/repo.git

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
- [Documentação do Django](https://docs.djangoproject.com/)
- [Documentação do Flask](https://flask.palletsprojects.com/)
- [Documentação do FastAPI](https://fastapi.tiangolo.com/)
