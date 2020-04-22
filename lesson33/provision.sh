#!/bin/bash
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

echo 'Копируем ключи для ansible'
cat /vagrant/ansible/ansible.pub >> ~vagrant/.ssh/authorized_keys
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
#yum install -y python python-apt
#yum install -y mc netstat lsof

#Отключаю сразу, что бы не перезагружаться.
setenforce 0
systemctl stop firewalld
# Отключаю SELinux, ничего личного.
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config


