#!/bin/bash

# Script para adicionar domínios ao /etc/hosts automaticamente
# Descobre dinamicamente os domínios dos vhosts do Nginx e adiciona ao /etc/hosts

# Diretório onde os vhosts do Nginx estão montados
VHOSTS_DIR="/etc/nginx/vhosts"

# Aguardar o container nginx estar disponível na rede Docker
for i in {1..30}; do
    NGINX_IP=$(getent hosts nginx 2>/dev/null | awk '{ print $1 }')
    if [ -n "$NGINX_IP" ]; then
        break
    fi
    sleep 1
done

if [ -z "$NGINX_IP" ]; then
    echo "⚠️  Não foi possível resolver o IP do nginx, usando fallback"
    # Tentar usar o IP do gateway da rede (geralmente .1)
    NGINX_IP=$(ip route | grep default | awk '{print $3}' | cut -d'.' -f1-3).1
    if [ -z "$NGINX_IP" ]; then
        echo "⚠️  Usando 127.0.0.1 como fallback"
        NGINX_IP="127.0.0.1"
    fi
fi

echo "✅ Configurando domínios para IP: $NGINX_IP"

# Extrair todos os domínios (server_name) dos arquivos de configuração do Nginx
# Usar arquivo temporário para evitar problemas com subshells
TEMP_DOMAINS_FILE=$(mktemp)

if [ -d "$VHOSTS_DIR" ]; then
    # Encontrar todos os arquivos .conf e processar um por vez
    for conf_file in "$VHOSTS_DIR"/*.conf; do
        # Verificar se o arquivo existe
        [ -f "$conf_file" ] || continue
        
        # Processar cada linha do arquivo
        while IFS= read -r line; do
            # Verificar se a linha contém server_name
            if echo "$line" | grep -q "server_name"; then
                # Remover comentários
                line=$(echo "$line" | sed 's/#.*$//')
                
                # Extrair a parte após server_name até o ;
                server_names=$(echo "$line" | sed -n 's/.*server_name[[:space:]]*\(.*\)[[:space:]]*;.*/\1/p')
                
                if [ -n "$server_names" ]; then
                    # Dividir por espaços e processar cada domínio
                    for domain in $server_names; do
                        # Remover espaços e caracteres especiais
                        domain=$(echo "$domain" | xargs)
                        # Ignorar domínios vazios, localhost e padrões especiais
                        if [ -n "$domain" ] && [ "$domain" != "localhost" ] && [ "$domain" != "_" ] && [ "$domain" != "default_server" ]; then
                            # Adicionar ao arquivo temporário (sem duplicatas)
                            if ! grep -q "^${domain}$" "$TEMP_DOMAINS_FILE" 2>/dev/null; then
                                echo "$domain" >> "$TEMP_DOMAINS_FILE"
                            fi
                        fi
                    done
                fi
            fi
        done < "$conf_file"
    done
    
    # Ler domínios únicos do arquivo temporário para o array
    DOMAINS=()
    if [ -f "$TEMP_DOMAINS_FILE" ] && [ -s "$TEMP_DOMAINS_FILE" ]; then
        while IFS= read -r domain; do
            [ -n "$domain" ] && DOMAINS+=("$domain")
        done < "$TEMP_DOMAINS_FILE"
        rm -f "$TEMP_DOMAINS_FILE"
    else
        rm -f "$TEMP_DOMAINS_FILE"
    fi
else
    echo "⚠️  Diretório de vhosts não encontrado: $VHOSTS_DIR"
fi

# Remover todas as entradas antigas dos domínios do /etc/hosts
# (isso evita duplicatas ao reiniciar o container)
if [ -f /etc/hosts ]; then
    # Criar arquivo temporário sem as entradas antigas
    grep -v "# Auto-added by entrypoint.sh" /etc/hosts > /tmp/hosts.tmp 2>/dev/null || cp /etc/hosts /tmp/hosts.tmp
    mv /tmp/hosts.tmp /etc/hosts
fi

# Adicionar todos os domínios encontrados ao /etc/hosts
if [ ${#DOMAINS[@]} -gt 0 ]; then
    echo "# Auto-added by entrypoint.sh - $(date)" >> /etc/hosts
    echo "✅ Domínios encontrados nos vhosts do Nginx:"
    for domain in "${DOMAINS[@]}"; do
        echo "$NGINX_IP $domain" >> /etc/hosts
        echo "   - $domain -> $NGINX_IP"
    done
    echo "✅ Total de ${#DOMAINS[@]} domínio(s) adicionado(s) ao /etc/hosts"
else
    echo "⚠️  Nenhum domínio encontrado nos vhosts do Nginx"
fi

# Executar o comando original (php-fpm)
exec "$@"

