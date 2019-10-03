      yum install epel-release -y
      yum update -y
      yum install -y ssh mc nginx systemd-journal-gateway
      curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.4.0-x86_64.rpm
      rpm -vi filebeat-6.4.0-x86_64.rpm
      # Разрешаем авторизацию по паролю - если запрещено
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd
      
      
      # Отключаю SELinux
      sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
      #Отключаю сразу, что бы не перезагружаться.
      setenforce 0
      cp /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf
      cp /vagrant/nginx/index.html /usr/share/nginx/html/index.html
      cp /vagrant/nginx/filebeat.yml /etc/filebeat/filebeat.yml
      systemctl enable nginx
      systemctl start nginx
      systemctl start filebeat
      systemctl enable filebeat
      cp /vagrant/nginx.rules /etc/audit/rules.d
      service auditd restart
      sed -i '/\[Upload\]/a URL=http://192.168.11.140:9600' /etc/systemd/journal-upload.conf
      echo "IP адрес машины " $(ip -4 a |grep inet --color)