
echo "[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/rhel/9/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/rhel/gpg" > /etc/yum.repos.d/docker.repo 
dnf install git net-tools unzip wget python3 python3-pip ansible-core -y
dnf install docker-ce --nobest 
ansible-galaxy collection install community.docker
sed -i 's/, ssl_version=tls_version//g' /usr/local/lib/python3.9/site-packages/compose/cli/docker_client.py
git clone https://github.com/yrmenezes79/Cloud_Infrastructure_as_Code.git
cd Cloud_Infrastructure_as_Code/awx/
unzip awx-17.1.0.zip
cd awx-17.1.0/installer/
