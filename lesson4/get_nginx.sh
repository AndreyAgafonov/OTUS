#!/bin/bash

# Cкрипт для процесса
# Генератор логов NGINX. из существующего набора src IPs и реквестов будем генерировать и записывать в лог файл лог NGINX
# Кроличество реквестов в секунду определдяем случайно.

cd /vagrant

while true
    do
    #Задаём значение rps (request per second)
    rps=$((1 + RANDOM % 100))
        for ((i=1;i<$rps;i++))
            do
			#Генерируем необходимое количество логов
            echo "$(shuf -n 1 ips.log) - - [`date +%d`"/"`date +%h`"/"`date +%G`":"`date +%T`" +0000] "$(shuf -n 1 request.log)" >>nginx.log
        done
    sleep 1
done



