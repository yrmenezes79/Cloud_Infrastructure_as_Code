#!/bin/bash

AWX_SERVER=""
USERNAME="admin"
PASSWORD=""
TEMPLATE_NAME="projeto1"
INVENTARIO=""
PROJETO=""
PLAYBOOK=""

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
check_return_code "Token obtido com sucesso"

FASE="Criar Template de Job"
curl -H "Authorization: Bearer $TOKEN" -X POST "http://$AWX_SERVER/api/v2/job_templates/" -H "Content-Type: application/json" -d '{
  "name": "Novo Template de Job",
  "description": "Descrição do Template",
  "job_type": "run",
  "inventory": $INVENTARIO,
  "project": $PROJETO,
  "playbook": $PLAYBOOK,
  "credential": null,
  "verbosity": 0,
  "extra_vars": {}
}'
check_return_code "Template de Job criado com sucesso"
