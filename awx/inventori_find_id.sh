#!/bin/bash

# Definir variáveis
AWX_SERVER="IP"
USERNAME="admin"
PASSWORD=""
INVENTORY_NAME="inv1"

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
TOKEN=$(curl -s -u "$USERNAME:$PASSWORD" -X POST "http://$AWX_SERVER/api/v2/tokens/" -H "Content-Type: application/json" | jq -r .token)
check_return_code "$FASE"

# Procurar pelo ID do inventário com o nome especificado
FASE="Procurar ID do Inventário"
INVENTORY_ID=$(curl -s -H "Authorization: Bearer $TOKEN" -X GET "http://$AWX_SERVER/api/v2/inventories/?name=$INVENTORY_NAME" -H "Content-Type: application/json" | jq -r ".results[] | select(.name==\"$INVENTORY_NAME\") | .id")
check_return_code "$FASE"

if [ -z "$INVENTORY_ID" ]; then
    echo "Inventário '$INVENTORY_NAME' não encontrado."
    exit 1
else
    echo "ID do Inventário '$INVENTORY_NAME': $INVENTORY_ID"
fi
