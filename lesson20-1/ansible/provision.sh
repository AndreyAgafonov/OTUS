#!/bin/bash
#===================VARIBLES========================
#    vagrant_dir="${vagrant_work_dir:-}" # /vagrant/'MashineName'
#    work_dir="/ansible"


#===================Понеслася========================
#Устанавливаем ansible
yum install -y epel-release
yum install -y ansible mc

#sudo easy_install pip
#pip install docker docker-py docker-compose

#делаем правильные права для приватного ключа
chmod 0600 /vagrant/ansible.pem
chmod 0600 /vagrant/ansible/ansible.pem

#создаем рабочую директорию
#mkdir $work_dir
#Наполняем рабочую директорию
#cp -R $vagrant_dir $work_dir

# меняем рабочий каталог
#cd $work_dir # Накуя только

echo "172.16.10.20 centralrouter" >> /etc/hosts
echo "172.16.10.30 inetrouter" >> /etc/hosts
echo "172.16.10.101 testClient1" >> /etc/hosts
echo "172.16.10.102 testClient2" >> /etc/hosts
echo "172.16.10.201 testServer1" >> /etc/hosts
echo "172.16.10.202 testServer2" >> /etc/hosts

# Устанавливаем Nginx
cd /vagrant/ansible
ansible-playbook startall.yml






