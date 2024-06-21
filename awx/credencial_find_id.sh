#!/bin/bash

AWX_SERVER="IP"
USERNAME="admin"
PASSWORD=""
CREDENTIAL_NAME="git"  #colocar nome da credencial

check_return_code() {
    local return_code=$?
    local message=$1

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
check_return_code "Obter Token de Autenticação"
log_debug "Token obtido: $TOKEN"

# Obter ID da Credencial SCM
FASE="Obter ID da Credencial SCM"
log_debug "Iniciando $FASE"
CREDENTIAL_RESPONSE=$(curl -H "Authorization: Bearer $TOKEN" -X GET "http://$AWX_SERVER/api/v2/credentials/?name=$CREDENTIAL_NAME" -H "Content-Type: application/json")
check_return_code "Obter ID da Credencial SCM"
log_debug "Resposta da API para obtenção da credencial: $CREDENTIAL_RESPONSE"

SCM_CREDENTIAL_ID=$(echo "$CREDENTIAL_RESPONSE" | jq -r '.results[0].id')
if [ "$SCM_CREDENTIAL_ID" == "null" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Erro: Falha ao obter ID da credencial SCM a partir da resposta da API"
    echo "Resposta completa: $CREDENTIAL_RESPONSE"
    exit 1
fi
log_debug "ID da Credencial SCM obtido: $SCM_CREDENTIAL_ID"

echo "ID da Credencial SCM: $SCM_CREDENTIAL_ID"
