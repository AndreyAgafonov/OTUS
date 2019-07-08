#!/usr/bin/env bash
#
# Доставляем файлы  сервиса в систему
cp /vagrant/logscript.service /etc/systemd/system/logscript.service
cp /vagrant/logscript.timer /etc/systemd/system/logscript.timer
cp /vagrant/logscript /etc/sysconfig/logscript
cp /vagrant/logscript.sh /opt/logscript.sh
# Подложим тестовый файлик
cp /vagrant/logfile.log /var/log/logfile.log
# Включим
systemctl daemon-reload
systemctl enable logscript.service
systemctl enable logscript.timer
systemctl start logscript.service
systemctl start logscript.timer

# Подключаем epel и ставим spawn-fcgi
yes | yum -y -q install epel-release
yes | yum -y -q install spawn-fcgi
# Для корректной работы нам нужно приложение, которое поддерживает интерфейс CGI (FastCGI, в частности)
# Пусть это будет apache2 с соответствующим модулем (httpd, mod_fcgid)
yes | yum -y -q install httpd mod_fcgid
rpm -ql spawn-fcgi
# Анализ файлов из пакета spawn-fcgi показывает, что он имеет скрипт init.d
# и, внезапно, файл /etc/sysconfig/spawn-cgi с закомментированными параметрами-примерами
# Раскомментируем.
sed -i 's/#SOCKET/SOCKET/' /etc/sysconfig/spawn-fcgi
sed -i 's/#OPTIONS/OPTIONS/' /etc/sysconfig/spawn-fcgi
# Нам понадобится php
yes | yum -y -q install php php-cli
# Установим подготовленный unit-файл
cp /vagrant/spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service
# Включим
systemctl enable spawn-fcgi
systemctl start spawn-fcgi


# Для запуска нескольких процессов  apache нам потребуется несколько разынх unit файлов, т.к. нам нужны разные PID 
# и разные порты для прослушивания для нацеливания на разные конфиги будем использовать опцию переменную COUNT
# в /usr/lib ломать ничего не будем - скопируем в административный каталог и будем делать всё там
# Необходимое количество разных процессов

systemctl disable httpd
systemctl daemon-reload
COUNT=3
for (( WEBS = 1; WEBS <= COUNT; WEBS++ ))
    do
    cp /usr/lib/systemd/system/httpd.service /usr/lib/systemd/system/httpd-${WEBS}.service
    sed -i "s%EnvironmentFile=\/etc\/sysconfig\/httpd%EnvironmentFile=\/usr\/lib\/systemd\/system\/httpd-config-${WEBS}%" /usr/lib/systemd/system/httpd-${WEBS}.service

    cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd-${WEBS}.conf
    sed -i "s%Listen 80%Listen 8${WEBS}%" /etc/httpd/conf/httpd-${WEBS}.conf
    sed -i "s%logs\/error_log%logs\/error_log-${WEBS}%" /etc/httpd/conf/httpd-${WEBS}.conf
    sed -i "s%logs\/access_log%logs\/access_log-${WEBS}%" /etc/httpd/conf/httpd-${WEBS}.conf
    sed -i "/ServerRoot \"\/etc\/httpd\"/a PidFile \/var\/run\/httpd-${WEBS}.pid" /etc/httpd/conf/httpd-${WEBS}.conf

    cp /etc/sysconfig/httpd /usr/lib/systemd/system/httpd-config-${WEBS}
    sed -i "s%#OPTIONS=%OPTIONS=-f \/etc\/httpd\/conf\/httpd-${WEBS}.conf%" /usr/lib/systemd/system/httpd-config-${WEBS}
#sed -i "s%#OPTIONS=%OPTIONS=-f \/etc\/httpd\/conf\/httpd-2.conf%" /usr/lib/systemd/system/httpd-config-2
    systemctl enable httpd-${WEBS}
    systemctl start httpd-${WEBS}
    sleep 5
done



# Подождём и проверим
#echo "Wait 30 sec for testing."
#sleep 35
#systemctl status logscript.service
#systemctl status logscript.timer
# Первое задание выполнено!
# И проверим
#systemctl status spawn-fcgi
# Работает!
# Второе задание выполнено!
#systemctl status httpd@1
#systemctl status httpd@2

#ss -tpnl | grep httpd | awk '{print $1,$4,$6}'
# Работает!
# Третье задание выполнено.
exit 0