#!/bin/bash

AWX_SERVER="IP"
USERNAME="admin"
PASSWORD=""
TEMPLATE_NAME="Template com Exemplo1"

# Função para verificar o código de retorno e exibir mensagem
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

# Obter Token de Autenticação
FASE="Obter Token de Autenticação"
TOKEN=$(curl -u "$USERNAME:$PASSWORD" -X POST "http://$AWX_SERVER/api/v2/tokens/" -H "Content-Type: application/json" | jq -r .token)
check_return_code "$FASE"

# Obter ID do Template de Job
FASE="Obter ID do Template de Job"
TEMPLATE_ID=$(curl -s -H "Authorization: Bearer $TOKEN" -X GET "http://$AWX_SERVER/api/v2/job_templates/?name=$TEMPLATE_NAME" | jq -r '.results[0].id')
check_return_code "$FASE"

echo "JOB_TEMPLATE_ID do template '$TEMPLATE_NAME' encontrado: $TEMPLATE_ID"
