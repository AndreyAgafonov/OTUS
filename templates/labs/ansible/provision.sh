#!/bin/bash    
#===================VARIBLES========================     
    vagrant_dir="${vagrant_work_dir:-}" # /vagrant/'MashineName'
    work_dir= "/ansible"


#===================Понеслася========================     
#Устанавливаем ansible
yum install -y ansible 


#создаем рабочую директорию
mkdir $work_dir
#Наполняем рабочую директорию
cp -R $vagrant_dir $work_dir

# меняем рабочий каталог
cd $work_dir # Накуя только


#Добавляем ключи для ansible
#копируем приватный ключ
#cp $work_dir/


