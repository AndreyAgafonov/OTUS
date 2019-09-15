#!/usr/bin/env bash
# Скрипт, который ищет заданное слово в заданном файле
# И при нахождении: пишет об этом в системный лог
LOG_TO_MON=$1
KEYWORD=$2

# Проверяем, что файл и ключевое слово были указаны
if [ -z $1 ] ; then
        echo "No file specified for analysis!"; exit 1
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

# Задаем константы и переменные
DATETIME=`date +%d/%b/%Y:%T" "%z`

# Выполняем поиск до первого совпадения
# Если совпадение было, то exit code = 0
grep --quiet $KEYWORD $LOG_TO_MON
# Проверяем exit code предыдущей команды и если он равен 0, то ....
if [[ $? -eq 0 ]]; then
    logger "LogMon - Found the keyword $KEYWORD at $DATETIME in $LOG_TO_MON"
    exit 0
    else
    exit 0
fi
# Конец. Выходим.
exit 0

