#!/bin/bash
LOGDIR=/vagrant/nginx_parser/log
LOGFILE=$LOGDIR'/sendmail.log'

# Будет отображаться "От кого"
FROM=otus@cloud16.ru

# Кому
MAILTO=$1
#MAILTO=aagafonov@inbox.ru

# Тема письма
SUBJECT=$2

# Тело письма
BODY=$3

SMTPSERVER=smtp.mail.ru
# Логин и пароль от учетной записи ДА ДА СОВСЕМ НЕ СЕКУРНО!
SMTPLOGIN="otus@cloud16.ru"
SMTPPASS="WOoHlXAD63JO5kz1HU54"


# Проверяем, существует ли $LOGDIR если нет - создаем его.
if [ ! -d $LOGDIR ] ;
        then
        mkdir -p $LOGDIR
fi
echo "$(date +%Y/%B/%m" "%T%t%Z) Запущен скрипт отправки сообщения." >>$LOGFILE

emailcheck() {
        echo "Проверяем корректность указания эл. почты получателя." >>$LOGFILE
        echo "$1" | egrep --quiet "^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
        if [ $? -ne 0 ] ;
                then
                echo "$(date +%Y/%B/%m" "%T%t%Z) Не верно указан адрес получателя!" >> $LOGFILE
                exit 1
        fi
}
echo "$(date +%Y/%B/%m" "%T%t%Z) проверка ОК!" >> $LOGFILE

#Перед отправлкой проверяем получаетеля письма
emailcheck 

# Отправляем письмо
/usr/sbin/sendmail -f "$FROM" -t "$MAILTO" -o message-charset=utf-8  -u "$NAME" -m "$BODY" -s "$SMTPSERVER" -o tls=yes -xu "$SMTPLOGIN" -xp "$SMTPPASS" && echo "$(date +%Y/%B/%m" "%T%t%Z) Письмо успешно отправлено" >> $LOGFILE


# sendmail -f otus@cloud16.ru -t aagafonov@inbox.ru -o message-charset=utf-8 -u "Photos..." -m "Тут идет небольшое тело письма..." -s smtp.mail.ru -o tls=tls-only -xu "otus@cloud16.ru" -xp "WOoHlXAD63JO5kz1HU54" -l log_file.txt 
echo "$(date +%Y/%B/%m" "%T%t%Z) работа скрипта завершена" >> $LOGFILE


