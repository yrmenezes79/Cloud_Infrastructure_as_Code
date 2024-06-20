#!/bin/bash
USER=admin
PASSWORD=
URL="http://IP"
ARQUIVO=response.json
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
TOKEN=$(curl -u $USER:$PASSWORD -X POST $URL/api/v2/tokens/ | jq -r '.token')
check_return_code

FASE="Consultar Credenciais"
# 
curl -H "Authorization: Bearer $TOKEN" $URL/api/v2/credentials/ > $ARQUIVO
check_return_code

cat $ARQUIVO |jq
