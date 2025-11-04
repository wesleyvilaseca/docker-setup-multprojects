-- Script de inicialização para aplicar configurações anti-deadlock
-- Este script é executado automaticamente quando o PostgreSQL é inicializado pela primeira vez
-- IMPORTANTE: Este script só roda na primeira inicialização (quando o banco é criado)
-- Para aplicar em um banco existente, execute manualmente via: docker-compose exec postgres psql -U postgres -f /docker-entrypoint-initdb.d/01-init-config.sql

-- Configurações de Deadlock
ALTER SYSTEM SET deadlock_timeout = '5s';
ALTER SYSTEM SET log_lock_waits = 'on';
ALTER SYSTEM SET log_deadlocks = 'on';

-- Configurações de Timeout
ALTER SYSTEM SET lock_timeout = '30s';
ALTER SYSTEM SET statement_timeout = '300s';
ALTER SYSTEM SET idle_in_transaction_session_timeout = '300s';

-- Configurações de Conexão
ALTER SYSTEM SET max_connections = '200';

-- Configurações de Memória
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET work_mem = '4MB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET effective_cache_size = '1GB';

-- Configurações de Log
ALTER SYSTEM SET log_min_duration_statement = '1000';

-- Configurações de Performance
ALTER SYSTEM SET random_page_cost = '1.1';
ALTER SYSTEM SET effective_io_concurrency = '200';
ALTER SYSTEM SET max_worker_processes = '8';
ALTER SYSTEM SET max_parallel_workers_per_gather = '4';
ALTER SYSTEM SET max_parallel_workers = '8';

-- Configurações de WAL
ALTER SYSTEM SET wal_level = 'replica';
ALTER SYSTEM SET max_wal_size = '1GB';
ALTER SYSTEM SET min_wal_size = '80MB';
ALTER SYSTEM SET checkpoint_completion_target = '0.9';

-- Reload para aplicar as configurações
SELECT pg_reload_conf();

