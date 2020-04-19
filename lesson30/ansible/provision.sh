#!/bin/bash
#===================VARIBLES========================
    vagrant_dir="${vagrant_work_dir:-}" # /vagrant/'MashineName'
    work_dir="/ansible"


#===================Понеслася========================
#Устанавливаем ansible
yum install -y epel-release
yum install -y ansible mc

#sudo easy_install pip
#pip install docker docker-py docker-compose

#делаем правильные права для приватного ключа
chmod 0600 /vagrant/ansible/ansible.pem

cd /vagrant/ansible
ansible-playbook mailserver.yml






