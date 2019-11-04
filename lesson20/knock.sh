#!/usr/bin/env bash
# Knockport script
# Для открытия пора используй : knock.sh 192.168.255.1 3333 9965
HOST=$1
shift
for ARG in "$@"
do
        nmap -Pn --host-timeout 100 --max-retries 0 -p $ARG $HOST
        read -p "Press key to continue.. " -n1 -s
done
#Для проверки сразу подключаемся на роутер и проверяем что 22 порт открыт
# проверка завершиться не удачей, т.к. нет SSH ключа. но без это скрипта мы даже не дащли бы до авторизации. т.е. скрипт работает как надо.
ssh vagrant@$HOST
