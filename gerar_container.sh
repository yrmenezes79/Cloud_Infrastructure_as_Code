VERSAO=$1
if [[ -z $VERSAO  ]]
        then
                VER=latest
else
                VER=$VERSAO
fi
echo "Gerando imagem Ansible EDA"
podman rm ansible
podman build -t eda-ansible:$VER .
echo "Executando a imagem"
podman run -d -p 5000:5000 --name ansible localhost/eda-ansible:$VER
podman ps
echo "Executar uma chamada"
curl -H 'Content-Type: application/json' -d '{"message": "localhost"}' 127.0.0.1:5000/endpoint
podman logs -f ansible

