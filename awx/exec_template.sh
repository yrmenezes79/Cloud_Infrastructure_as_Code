#!/bin/bash

# Configurações
AWX_SERVER="awx.example.com"
USERNAME="your_username"
PASSWORD="your_password"
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
response=$(curl -H "Authorization: Bearer $TOKEN" -X POST "http://$AWX_SERVER/api/v2/job_templates/$JOB_TEMPLATE_ID/launch/" -H "Content-Type: application/json")
job_id=$(echo $response | jq -r .job)
check_return_code

# Monitorar o Status do Job
while true; do
  status=$(curl -H "Authorization: Bearer $TOKEN" -X GET "http://$AWX_SERVER/api/v2/jobs/$job_id/" -H "Content-Type: application/json" | jq -r .status)
  echo "Current job status: $status"
  
  if [[ "$status" == "successful" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') Job completed successfully."
    break
  elif [[ "$status" == "failed" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') Job failed."
    break
  else
    echo "$(date '+%Y-%m-%d %H:%M:%S') Job is $status..."
    sleep 10  # Aguarde 10 segundos antes de verificar novamente
  fi
done
