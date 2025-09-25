#!/bin/bash

# Cores para saída
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sem cor

echo -e "${YELLOW}Atualizando pacotes...${NC}"
sudo yum update -y || { echo -e "${RED}Falha ao atualizar pacotes${NC}"; exit 1; }

echo -e "${YELLOW}Instalando dependências...${NC}"
sudo yum install -y unzip curl python3 python3-pip || { echo -e "${RED}Falha ao instalar dependências${NC}"; exit 1; }

echo -e "${YELLOW}Instalando AWS CLI v2...${NC}"
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install --update
aws --version || { echo -e "${RED}Falha ao instalar AWS CLI${NC}"; exit 1; }

echo -e "${YELLOW}Instalando Ansible...${NC}"
# Em versões novas do RHEL pode precisar habilitar repositório EPEL
sudo dnf install ansible-core python-pip 
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install boto3 botocore
sudo ansible-galaxy collection install amazon.aws --force

ansible --version || { echo -e "${RED}Falha ao instalar Ansible${NC}"; exit 1; }

echo -e "${GREEN}Instalação concluída com sucesso!${NC}"

ansible --version
aws --vsrsion
