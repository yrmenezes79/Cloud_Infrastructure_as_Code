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

FASE="Repositorio Docker"
echo "$(date '+%Y-%m-%d %H:%M:%S') - $FASE"

check_return_code "$FASE"

FASE=""
echo "$(date '+%Y-%m-%d %H:%M:%S') - $FASE"
echo "[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/rhel/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/rhel/gpg" > /etc/yum.repos.d/docker.repo 
check_return_code "$FASE"

FASE="Instalacao de pacotes"
echo "$(date '+%Y-%m-%d %H:%M:%S') - $FASE"
dnf install git net-tools unzip wget python3 python3-pip ansible-core -y
check_return_code "$FASE"
dnf install docker-ce --nobest -y
check_return_code "$FASE"

dnf install docker-ce --nobest 
ansible-galaxy collection install community.docker
sed -i 's/, ssl_version=tls_version//g' /usr/local/lib/python3.9/site-packages/compose/cli/docker_client.py
git clone https://github.com/yrmenezes79/Cloud_Infrastructure_as_Code.git
cd Cloud_Infrastructure_as_Code/awx/
unzip awx-17.1.0.zip
cd awx-17.1.0/installer/
