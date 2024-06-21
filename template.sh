#!/bin/bash

AWX_SERVER="IP"
USERNAME="admin"
PASSWORD=""
PROJECT_ID=8  # ID do projeto onde o playbook Exemplo1.yml está localizado
INVENTORY_ID=2  # Substitua pelo ID do seu inventário

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

# Criar Template de Job
FASE="Criar Template de Job"
log_debug "Iniciando $FASE"
JOB_TEMPLATE_RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" -X POST "http://$AWX_SERVER/api/v2/job_templates/" -H "Content-Type: application/json" -d '{
  "name": "Template com Exemplo1",
  "description": "Template inicial com playbook Exemplo1.yml",
  "job_type": "run",
  "inventory": '"$INVENTORY_ID"',
  "project": '"$PROJECT_ID"',
  "playbook": "Exemplo1.yml",
  "verbosity": 0
}')
check_return_code $? "Template de Job criado com sucesso"
log_debug "Resposta da API para criação do template de job: $JOB_TEMPLATE_RESPONSE"

JOB_TEMPLATE_ID=$(echo "$JOB_TEMPLATE_RESPONSE" | jq -r .id)
if [ -z "$JOB_TEMPLATE_ID" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Erro: Falha ao obter ID do template de job a partir da resposta da API"
    echo "Resposta completa: $JOB_TEMPLATE_RESPONSE"
    exit 1
fi
log_debug "ID do Template de Job criado: $JOB_TEMPLATE_ID"

echo "Template de Job criado com sucesso!"
