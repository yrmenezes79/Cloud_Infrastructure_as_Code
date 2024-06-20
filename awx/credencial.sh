#!/bin/bash
USER=admin
PASSWORD=
URL="http://IP"

# Obter Token de Autenticação
TOKEN=$(curl -u $USER:$PASSWORD -X POST $URL/api/v2/tokens/ | jq -r '.token')

# Consultar Credenciais
curl -H "Authorization: Bearer $TOKEN" $URL/api/v2/credentials/ > teste.json

cat teste.json |jq
