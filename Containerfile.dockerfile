FROM registry.access.redhat.com/ubi9/ubi:latest

RUN dnf --assumeyes install python3-pip maven java-17-openjdk-devel openssh-clients

ENV ANSIBLE_HOST_KEY_CHECKING=False

ENV JDK_HOME=/usr/lib/jvm/java-17-openjdk \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk \
    PATH=$PATH:$JAVA_HOME/bin

RUN pip3 install -U pip \
    && pip3 install ansible ansible-rulebook ansible-runner wheel

RUN ansible-galaxy collection install ansible.eda

WORKDIR /etc/ansible

ADD inventory.ini /etc/ansible/
ADD rulebook.yml /etc/ansible/
ADD playbook_server1.yml /etc/ansible/

EXPOSE 5000

CMD ["ansible-rulebook","--rulebook","rulebook.yml","-i","inventory.ini","-vv"]