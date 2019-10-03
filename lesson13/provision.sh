#!/bin/bash         
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh   

#Копируем ключи для ansible
cat /vagrant/ansible.pub >> ~vagrant/.ssh/authorized_keys

#ставим ну почти необходимое для работы ansible и не только
#yes| yum install epel-release
#yum update -y
yum install -y python python-apt lsof htop mc

