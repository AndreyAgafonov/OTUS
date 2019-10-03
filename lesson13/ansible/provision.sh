#!/bin/bash    
#===================VARIBLES========================     
    vagrant_dir="${vagrant_work_dir:-}" # /vagrant/'MashineName'
    work_dir= "/ansible"


#===================Понеслася========================     
#Устанавливаем ansible
yum install -y epel-release
yum install -y ansible 

#делаем правильные права для приватного ключа
chmod 0600 /vagrant/ansible.pem

#создаем рабочую директорию
mkdir $work_dir
#Наполняем рабочую директорию
cp -R $vagrant_dir $work_dir

# меняем рабочий каталог
cd $work_dir # Накуя только

# устанавливаем  веб сервер
cd /vagrant/ansible/roles
ansible-playbook nginx.yml

#Добавляем ключи для ansible
#копируем приватный ключ
#cp $work_dir/


