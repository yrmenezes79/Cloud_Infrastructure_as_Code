echo "Gerando imagem Ansible EDA"
podman build -t eda-ansible .
echo "Fim da geração da imagem"
echo "Executando a imagem"
podman run -d -p 8000:8000 localhost/eda-ansible
podman ps
