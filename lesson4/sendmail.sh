#!/bin/bash

# Будет отображаться "От кого"
FROM=otus@cloud16.ru
# Кому
MAILTO=aagafonov@inbox.ru
# Тема письма
NAME=$1
# Тело письма
BODY=$2

SMTPSERVER=smtp.mail.ru
# Логин и пароль от учетной записи gmail.com
SMTPLOGIN=otus@cloud16.ru
SMTPPASS=WOoHlXAD63JO5kz1HU54

# Отправляем письмо
/usr/sbin/sendmail -f $FROM -t $MAILTO -o message-charset=utf-8  -u $NAME -m $BODY -s $SMTPSERVER -o tls=yes -xu $SMTPLOGIN -xp $SMTPPASS




emailcheck() {
        echo "Checking email."
        echo "$1" | egrep --quiet "^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
        if [ $? -ne 0 ] ;
                then
                echo "Invalid email address!"
                exit 1
                else
                echo "Email check - OK!"
        fi
}