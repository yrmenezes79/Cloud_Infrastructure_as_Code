# Usar a imagem base da Red Hat Universal Base Image 9
FROM registry.access.redhat.com/ubi9/ubi:latest

# Instalar pacotes necessários
RUN dnf --assumeyes install python3-pip maven java-17-openjdk-devel openssh-clients

# Definir a variável de ambiente ANSIBLE_HOST_KEY_CHECKING como False
ENV ANSIBLE_HOST_KEY_CHECKING=False

# Configurar variáveis de ambiente para Java
ENV JDK_HOME=/usr/lib/jvm/java-17-openjdk \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk \
    PATH=$PATH:$JAVA_HOME/bin

# Validar instalação do Java
RUN echo "Java installations:" && ls -l /usr/lib/jvm/ && java -version && echo $JAVA_HOME && ls -l $JAVA_HOME

# Atualizar pip e instalar pacotes Python
RUN pip3 install -U pip \
    && pip3 install ansible ansible-rulebook ansible-runner wheel

# Instalar coleções Ansible necessárias
RUN ansible-galaxy collection install ansible.eda

# Criar um diretório de trabalho
WORKDIR /etc/ansible

# Adicionar arquivos de configuração
ADD inventory.ini /etc/ansible/
ADD rulebook.yml /etc/ansible/
ADD playbook_server1.yml /etc/ansible/
ADD playbook_server2.yml /etc/ansible/

# Expor a porta 5000 para o webhook
EXPOSE 5000

# Comando para iniciar o ansible-rulebook
CMD ["ansible-rulebook", "--rulebook", "rulebook.yml", "-i", "inventory.ini", "-vv"]


