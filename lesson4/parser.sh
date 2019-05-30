#!/bin/bash
#
# написать скрипт для крона
#который раз в час присылает на заданную почту 
#- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
#- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
# - все ошибки c момента последнего запуска
#- список всех кодов возврата с указанием их кол-ва с момента последнего запуска в письме должно быть прописан обрабатываемый временной диапазон должна быть реализована защита от мультизапуска
# Критерии оценки: 
# трапы и функции, а также sed и find +1 балл

#===================Переменные==================

# Место положение лог nginx (можно при необхоидмсти заменить на опцию для скрипта, либо  вытащить из конфига NGINX
LOGFILE=/vagrant/nginx.log
LOGDIR=/var/log/nginx_parser
PASRSERLOGFILE=$LOGDIR'/'`date +%F`'.nginx_parser.log'
PIDFILE=/var/run/nginx_parser.pid
WORKDIR=/vagrant/nginx_parser
HISTDIR=$WORKDIR'/history'
SCRIPTTIME=`date +%d/%b/%Y:%T" "%z`

# Объявляем пути до рабочих файлов
LASTRUN=$WORKDIR'/nginx_parser.lastrun'
TMPFILE=$WORKDIR'/nginx_parser.tmp'
RESULTFILE=$WORKDIR'/nginx_parser.result'


CURRENTDATE='date'
LASTRUN='date'



#======================Понеслась====================
# Проверяем, существует ли LOGDIR если нет - создаем его.
if [ ! -d $LOGDIR ] ;
        then
        mkdir -p $LOGDIR
fi
# Фиксируем время запуска скрипта и потом запишем в рабочий файл
BEGIN=$SCRIPTTIME
echo "begin analysing" >> $PASRSERLOGFILE

# проверяем что файл LOGFILE существует
if [ ! -e $LOGFILE ] ;
        then
		touch $PASRSERLOGFILE
        echo "$1 is not exists! No file specified for analysis!" >> $PASRSERLOGFILE; exit 1
fi
if [ -d $LOGFILE ] ;
        then
        echo "$1 is a directory!" >> $PASRSERLOGFILE; exit 1
fi


# Защита от мультизапуска:
# Запретим перезапись файлов через перенаправление вывода и
# и попробуем записать в PIDFILE наш pid.
# Если операция завершится с exitcode != 0, значит файл существует - выходим
set -C
echo $$ > $PIDFILE 2>/dev/null || { echo "PIDFILE $PIDFILE exists!"; exit 1; }
set +C

# Используем trap:
# При выходе удаляем PIDFILE и мусор
trap "rm -f $PIDFILE $TMPFILE; exit" INT TERM EXIT


# С помоью find находим старые файлы и удаляем их
find $TMPFILE 2>/dev/null && rm -f $TMPFILE
find $RESULTFILE 2>/dev/null && rm -f $RESULTFILE

# Проверяем наличие файла с меткой о последнем запуске и создаём его, если таковой отсутствует, добавляя туда номер строки
if [ ! -e $LASTRUN ] ;
        then
        echo "$LASTRUN not exist. Analysing from begin." >> $PASRSERLOGFILE
        echo "1" > $LASTRUN
fi

# Сообщаем о времени. с которого начнётся анализ лога
LASTTIME=`tail -n 1 $LASTRUN`
echo "Start analysing from $LASTTIME"
#
# Копируем данные из источника в рабочий файл
cat $1 > $TMPFILE
#
# Добавляем в файл временную метку для сортировки, сортируем м отрезаем лишнее
echo "0.0.0.0 - - [$LASTTIME] specialmark1" >> $TMPFILE
echo "0.0.0.0 - - [$BEGIN] specialmark2" >> $TMPFILE
sort -o $TMPFILE -t ' ' -k 4.9,4.12n -k 4.5,4.7M -k 4.2,4.3n -k 4.14,4.15n -k 4.17,4.18n -k 4.20,4.21n $TMPFILE
sed -i '0,/specialmark1/d' $TMPFILE
sed -i '/specialmark2/,$d' $TMPFILE
#
# Пишем функцию, которой передадим файл для анализа и файл для записи результата
analyse() {
        FTARGETFILE=$1
        FRESULTFILE=$2
        ASTART=`head -n 1 $1 |awk '{print $4,$5}'`
        AFINISH=`tail -n 1 $1 |awk '{print $4,$5}'`
        echo "---" > $2
        echo "Script start time - $BEGIN" >> $2
        echo "Log has been analyzed from $ASTART to $AFINISH" >> $2
        echo "---" >> $2
        echo "The list of addresses with the most requests to the server (top 10 req-IP pairs)" >> $2
        cat $1 |awk '{print $1}' |sort |uniq -c |sort -rn| head >> $2
        echo "---" >> $2
        echo "The list of server resources with the most requests from the clients (top 10 req-res pairs)" >> $2
        cat $1 |awk '{print $7}' |sort |uniq -c |sort -rn| head >> $2
        echo "---" >> $2
        echo "Total number of errors (status codes 4xx and 5xx, number-code pairs)" >> $2
        cat $1 |awk '{print $9}' |grep -E "[4-5]{1}[0-9][0-9]" |sort |uniq -c |sort -rn >> $2
        echo "---" >> $2
        echo "The list of status codes with their total number (number-code pairs)" >> $2
        cat $1 |awk '{print $9}' |sort |uniq -c |sort -rn >> $2
        echo "---" >> $2
}
#
# Выполняем анализ и отправляем письмо
analyse $TMPFILE $RESULTFILE
cat $RESULTFILE | mail -s "Message fron NGINX parser" $ADDRESS
#
# Делаем копию отправленного файла, прибираемся и ставим метку последнего запуска
cp $RESULTFILE $HISTORYDIR'/nginx_parser-'`date +%d%b%Y-%T`'.result'
rm -f $RESULTFILE
echo $BEGIN > $LASTRUN
exit 0










#count IP 
#count errors
#return code
awk -F"" '{pront $}' |sort -nu
cat nginx.log |awk -F" " '{print $9}'|sort -n |uniq -c



>>









# Andrey Agafonov , aagafonov@inbox.ru, 2019