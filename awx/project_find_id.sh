#!/bin/bash

AWX_SERVER="IP"
USERNAME="admin"
PASSWORD=""
PROJECT_NAME="Projeto1"

check_return_code() {
    local return_code=$1
    local message=$2

    if [ $return_code -ne 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Erro: $message (Código de retorno: $return_code)"
        exit $return_code
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Sucesso: $message"
    fi
}

log_debug() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Debug: $message"
}

# Obter Token de Autenticação
FASE="Obter Token de Autenticação"
log_debug "Iniciando $FASE"
TOKEN=$(curl -u "$USERNAME:$PASSWORD" -X POST "http://$AWX_SERVER/api/v2/tokens/" -H "Content-Type: application/json" | jq -r .token)
check_return_code $? "Obter Token de Autenticação"
log_debug "Token obtido: $TOKEN"

# Buscar ID do Projeto
FASE="Buscar ID do Projeto $PROJECT_NAME"
log_debug "Iniciando $FASE"
PROJECT_RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" -X GET "http://$AWX_SERVER/api/v2/projects/?name=$PROJECT_NAME")
check_return_code $? "Buscar ID do Projeto $PROJECT_NAME"
PROJECT_ID=$(echo "$PROJECT_RESPONSE" | jq -r '.results[0].id')
if [ -z "$PROJECT_ID" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Erro: Projeto '$PROJECT_NAME' não encontrado."
    exit 1
fi
log_debug "ID do Projeto '$PROJECT_NAME' encontrado: $PROJECT_ID"
