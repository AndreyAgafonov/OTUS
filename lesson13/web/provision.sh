#!/bin/bash
#================Variables=====================
    vagrant_dir='/vagrant'
    vagant_box=${vagrant_box_name:-} # MashineName
    vagrant_dir="${vagrant_dir}'/'${vagrant_box}" # /vagrant/'MashineName'
    vagrant_mach=${vagrant_machines}

#================Понеслася=====================
        echo ${vagrant_mach}
        echo ${vagrant_dir}
        exit 0

      #устанавливаем пакеты ngixn и systemd-journal-gateway для удаленной передачи логов
      yum install -y ssh nginx systemd-journal-gateway
      
      #filebeat для парса логов
      curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.4.0-x86_64.rpm
      rpm -vi filebeat-6.4.0-x86_64.rpm
      
      # Отключаю SELinux, Ибо  нечего
      sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
      
      #Отключаю сразу, что бы не перезагружаться.
      setenforce 0

      cp $vagrant_dir/nginx.conf /etc/nginx/nginx.conf
      cp $vagrant_dir/index.html /usr/share/nginx/html/index.html
      cp $vagrant_dir/filebeat.yml /etc/filebeat/filebeat.yml
      systemctl enable nginx
      systemctl start nginx
      systemctl start filebeat
      systemctl enable filebeat
      cp /vagrant/nginx.rules /etc/audit/rules.d
      service auditd restart
      sed -i '/\[Upload\]/a URL=http://192.168.11.140:9600' /etc/systemd/journal-upload.conf
      



        
        echo "IP адрес машины: " $(ip -4 a |grep inet --color)
        