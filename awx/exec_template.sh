#!/bin/bash

# Configurações
AWX_SERVER="IP"
USERNAME="admin"
PASSWORD=""
TEMPLATE_NAME="projeto1"

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

FASE="Obter Token de Autenticação"
TOKEN=$(curl -u "$USERNAME:$PASSWORD" -X POST "http://$AWX_SERVER/api/v2/tokens/" -H "Content-Type: application/json" | jq -r .token)
check_return_code

FASE="Obter ID do Template de Job"
JOB_TEMPLATE_ID=$(curl -H "Authorization: Bearer $TOKEN" -X GET "http://$AWX_SERVER/api/v2/job_templates/" -H "Content-Type: application/json" | jq -r ".results[] | select(.name==\"$TEMPLATE_NAME\") | .id")
check_return_code

FASE="Iniciar o Template de Job"
curl -H "Authorization: Bearer $TOKEN" -X POST "http://$AWX_SERVER/api/v2/job_templates/$JOB_TEMPLATE_ID/launch/" -H "Content-Type: application/json"
check_return_code

