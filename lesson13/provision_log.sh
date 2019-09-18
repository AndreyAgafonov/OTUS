		  
        yum install epel-release -y
        yum update -y
        yum install ssh mc wget net-tools lsof -y
        # Отключаю SELinux - пока не понимаю почему блокируется
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        #Отключаю сразу, что бы не перезагружаться.
        setenforce 0
        # Разрешаем авторизацию по паролю - если запрещено
        sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        systemctl restart sshd
        
        wget https://s3-eu-west-1.amazonaws.com/portal-custom-assets.smartcat.ai/jre-8u211-linux-x64.rpm
        yum install -y jre-8u211-linux-x64.rpm
        rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
        cp /vagrant/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
        yum install -y elasticsearch kibana nginx logstash wget systemd-journal-gateway
        systemctl daemon-reload
        systemctl enable elasticsearch.service
        systemctl start elasticsearch.service
        systemctl enable kibana.service
        systemctl start kibana.service
        cp /vagrant/nginx.conf /etc/nginx/nginx.conf
        systemctl enable nginx.service
        systemctl start nginx.service
        cp /vagrant/input.conf /etc/logstash/conf.d
        cp /vagrant/output.conf  /etc/logstash/conf.d
        cp /vagrant/filter.conf  /etc/logstash/conf.d
        systemctl enable logstash.service
        cd /etc/logstash
        wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
        gunzip GeoLite2-City.mmdb.gz
        sed -i 's/# http.port: 9600-9700/http.port: 9600-9700/' /etc/logstash/logstash.yml
        #sed -i '/[Upload]/a '
        systemctl start logstash.service
        mkdir -p /var/log/journal/remote
        chown systemd-journal-remote:systemd-journal-remote /var/log/journal/remote
        sed -i 's/listen-https/listen-http/' /lib/systemd/system/systemd-journal-remote.service
        systemctl daemon-reload
        systemctl start systemd-journal-remote

        ip -4 a |grep inet --color