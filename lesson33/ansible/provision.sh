#!/bin/bash

#Устанавливаем ansible
yum install -y epel-release
yum install -y ansible mc

#sudo easy_install pip
#pip install docker docker-py docker-compose

#делаем правильные права для приватного ключа
chmod 0600 /vagrant/ansible.pem
#cat /vagrant/ansible/hosts >> /etc/hosts

# Тест зависимотей ролей - docker <- prepare
cd /vagrant/ansible
# Устанавливаем Kibana
#ansible-playbook install_kibana.yml
# Устанавливаем Nginx
#ansible-playbook install_nginx.yml
# Устанавливаем сервер удаленного прияема логов
ansible-playbook postgres-cluster.yml



