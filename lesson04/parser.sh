#!/bin/bash
#
# написать скрипт для крона
# который раз в час присылает на заданную почту 
#- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
#- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
# - все ошибки c момента последнего запуска
#- список всех кодов возврата с указанием их кол-ва с момента последнего запуска в письме должно быть прописан обрабатываемый временной диапазон должна быть реализована защита от мультизапуска
# Критерии оценки: 
# трапы и функции, а также sed и find +1 балл

#===================Переменные==================

# Место положение лог nginx (можно при необхоидмсти заменить на опцию для скрипта, либо  вытащить из конфига NGINX
LOGFILE=/vagrant/nginx.log
LOGDIR=/vagrant/nginx_parser/log
PARSERLOGFILE=$LOGDIR'/'`date +%F`'.nginx_parser.log'
PIDFILE=/var/run/nginx_parser.pid
WORKDIR=/vagrant/nginx_parser
HISTDIR=$WORKDIR'/history'
RUNTIME=$(date +%Y/%B/%m" "%T%t%Z)
#STOPTIME - в
#LINESTART= Здесь будет значение с номер строки из последнего запуска
LINEEND=$(wc -l $LOGFILE|awk '{print $1}')
# Объявляем пути до рабочих файлов
LASTRUN=$WORKDIR'/nginx_parser.lastrun'
TMPFILE=$WORKDIR'/nginx_parser.tmp'
RESULTFILE=$WORKDIR'/nginx_parser.result'


#======================Понеслась====================
# Проверяем, существует ли $WORKDIR если нет - создаем его.
if [ ! -d $WORKDIR ] ;
        then
        mkdir -p $WORKDIR
fi
# Проверяем, существует ли $LOGDIR если нет - создаем его.
if [ ! -d $LOGDIR ] ;
        then
        mkdir -p $LOGDIR
fi
# Проверяем, существует ли $HISTDIR если нет - создаем его.
if [ ! -d $HISTDIR ] ;
        then
        mkdir -p $HISTDIR
fi
# Фиксируем время запуска скрипта и потом запишем в рабочий файл
echo "$RUNTIME Запуск скрипта" >> $PARSERLOGFILE

# проверяем что файл LOGFILE существует
if [ ! -e $LOGFILE ] ;
        then
        echo "$(date +%Y/%B/%m" "%T%t%Z) Лог файл $1 для анализа на нейден! Анализировать нече, курим!!" >> $PARSERLOGFILE; exit 1
fi
if [ -d $LOGFILE ] ;
        then
        echo "$(date +%Y/%B/%m" "%T%t%Z) $1 ОООО, да это папка, нафиг нафиг, мы так не договаривались!" >> $PARSERLOGFILE; exit 1
fi


# Защита от мультизапуска: Запретим перезапись файлов через перенаправление вывода и
# и попробуем записать в PIDFILE наш pid. Если операция завершится с exitcode != 0,
# значит файл существует - выход 1.
set -C
echo $$ > $PIDFILE 2>/dev/null || { echo "$(date +%Y/%B/%m" "%T%t%Z) PIDFILE $PIDFILE Обнаружен. Скрипт уже работает! Завершите снакчала выполнение текущего скрипта."; exit 1; }
set +C

# Используем trap: При выходе удаляем PIDFILE и мусор
trap "rm -f $PIDFILE $TMPFILE; exit" INT TERM EXIT


# С помоью find находим старые файлы и удаляем их
find $TMPFILE 2>/dev/null && rm -f $TMPFILE
find $RESULTFILE 2>/dev/null && rm -f $RESULTFILE

# Проверяем наличие файла с меткой о последнем запуске и создаём его, если таковой отсутствует, добавляя туда номер строки
if [ ! -e $LASTRUN ] ;
        then
        echo "$(date +%Y/%B/%m" "%T%t%Z) $LASTRUN Не найден. Начинаем просмотр сначала." >> $PARSERLOGFILE
        echo "1" > $LASTRUN
fi
        LINESTART=$(cat $LASTRUN)
        echo "$(date +%Y/%B/%m" "%T%t%Z) Анализируем лог с $LINESTART строки." >> $PARSERLOGFILE
        # Фиксируем последнюю строку в файле метке

# Копируем анализируемый диапазон  из источника в временный файл
let "DELTA = LINEEND - LINESTART + 1"
head -n $LINEEND $LOGFILE |tail -n $DELTA  > $TMPFILE

# Функция, которая формирует текст для письма
parser() {
        # $1 - файл для анализа
        # $2 - файл результат анализа
        TIMEFROM=$(cat $1|head -n 1 |awk -F" " '{print $4}'|sed "s/\[//")
        TIMETO=$(cat $1|tail -n 1 |awk -F" " '{print $4}'|sed "s/\[//")
        echo "______________________" > $2
        echo "Обрабатываемый временной диапазон с " $TIMEFROM  " по " $TIMETO >> $2
        echo "______________________" >> $2
        echo "ТОП IP адресов с максимальным количеством запросов " >> $2
        cat $1 |awk '{print $1}' |sort |uniq -c |sort -rn| head >> $2
        echo "______________________" >> $2
        echo "ТОП запросов" >> $2
        cat $1 |awk '{print $7}' |sort |uniq -c |sort -rn| head >> $2
        echo "______________________" >> $2
        echo "Полное количество ошибок (4ххб 5хх)" >> $2
        cat $1 |awk '{print $9}' |egrep "^4|^5"|sort |uniq -c |sort -rn >> $2
        echo "______________________" >> $2
        echo "Все статусы запросов " >> $2
        cat $1 |awk '{print $9}' |sort |uniq -c |sort -rn >> $2
        echo "______________________" >> $2
}


# Выполняем анализ и отправляем письмо
parser $TMPFILE $RESULTFILE

MAILTO="aagafonov@inbox.ru"
SUBJECT="Parser NGINX Log $(date +%Y/%B/%m" "%T%t%Z)"
BODY=$(cat $RESULTFILE)
bash ./sendmail.sh $MAILTO $SUBJECT $BODY

# Делаем копию отправленного файла, прибираемся и ставим метку последнего запуска
cp $RESULTFILE $HISTDIR'/nginx_parser-'`date +%d%b%Y-%T`'.result'
rm -f $RESULTFILE

# Оставляем  местку с какой строки стартовать в следующий раз.
echo $LINEEND > $LASTRUN
echo "$(date +%Y/%B/%m" "%T%t%Z) Работа скрипта завершена"  >> $PARSERLOGFILE
exit 0

# Андрей Агафонов , aagafonov@inbox.ru, 2019