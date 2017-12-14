#!/usr/bin/env bash
function install {
    install_basic_util
    # install_nginx
    # install_docker
    # install_python3
    # install_ansible
}

function install_basic_util {
    yum clean all
    yum install -y gcc
    yum install -y vim
}

function install_nginx {
    echo '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1'> /etc/yum.repos.d/nginx.repo
    yum install -y nginx
    nginx
}

function install_docker {
    yum install -y docker
    groupadd docker
    usermod -aG docker ifnoelse
    mkdir -p /etc/docker
    echo '{"registry-mirrors": ["https://d6at4uvr.mirror.aliyuncs.com"]}'> /etc/docker/daemon.json
    systemctl daemon-reload
    systemctl restart docker
}

function install_python3 {
    yum -y install zlib*
    yum -y install openssl
    yum -y install openssl-devel
    wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz
    mv Python-3.6.3.tgz /usr/local/src/
    cd /usr/local/src/
    sudo tar -xzvf Python-3.6.3.tgz
    cd Python-3.6.3
    ./configure --prefix=/usr/local/python3
    make all
    make install
    ln -s /usr/local/python3/bin/python3 /usr/bin/python3
    ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
}

function install_ansible {
    install_python3
    pip3 install ansible
    ln -s /usr/local/python3/bin/ansible  /usr/bin/ansible
}

install