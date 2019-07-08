#!/usr/bin/env bash
# Скрипт, который ищет заданное слово в заданном файле
# А если нашел - пишет об этом в системный лог.
LOG_SCRIPT=$1
KWRD=$2

# Проверяем, что файл и ключевое слово были указаны
if [ -z $1 ] ; then
        echo "No file exspecifiedist!"; exit 1
fi
if [ -z $2 ] ; then
        echo "No keyword specified!"; exit 1
fi

# Проверяем, что целевой файл есть и это не каталог
if [ ! -e $1 ] ; then
        echo "$1 is not exists!"; exit 1
fi
if [ -d $1 ] ; then
        echo "$1 is a directory!"; exit 1
fi

# Задаем переменную даты для  указания в лог файле
DATETIME=`date +%d/%b/%Y:%T" "%z`
# Выполняем поиск до первого совпадения, если совпадение было, то exit code = 0
grep --quiet $KWRD $LOG_SCRIPT
# Проверяем exit code предыдущей команды и если он равен 0, то пишем в сислог
if [[ $? -eq 0 ]]; then
    echo "В $LOG_SCRIPT найдено слово $KWRD в $DATETIME"
    logger "В $LOG_SCRIPT найдено слово $KWRD в $DATETIME"
    exit 0
    else
    exit 0
fi
exit 0

