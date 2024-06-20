#!/bin/bash
USER=admin
PASSWORD=
URL="http://IP"
ARQUIVO=response.json

# Obter Token de Autenticação
TOKEN=$(curl -u $USER:$PASSWORD -X POST $URL/api/v2/tokens/ | jq -r '.token')

# Consultar Credenciais
# Consultar Inventários
curl -H "Authorization: Bearer $TOKEN" "$URL/api/v2/inventories/" | jq > $ARQUIVO

cat $ARQUIVO |jq
