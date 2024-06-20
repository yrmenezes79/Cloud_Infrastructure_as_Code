#!/bin/bash

# Configurações
AWX_SERVER="IP"
USERNAME="admin"
PASSWORD=""
TEMPLATE_NAME="projeto1"

# Obter Token de Autenticação
TOKEN=$(curl -u "$USERNAME:$PASSWORD" -X POST "http://$AWX_SERVER/api/v2/tokens/" -H "Content-Type: application/json" | jq -r .token)

# Obter ID do Template de Job
JOB_TEMPLATE_ID=$(curl -H "Authorization: Bearer $TOKEN" -X GET "http://$AWX_SERVER/api/v2/job_templates/" -H "Content-Type: application/json" | jq -r ".results[] | select(.name==\"$TEMPLATE_NAME\") | .id")

# Iniciar o Template de Job
curl -H "Authorization: Bearer $TOKEN" -X POST "http://$AWX_SERVER/api/v2/job_templates/$JOB_TEMPLATE_ID/launch/" -H "Content-Type: application/json"

echo "Template $TEMPLATE_NAME iniciado com sucesso."
