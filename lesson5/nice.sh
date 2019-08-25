#!/usr/bin/env bash
#Подчищаем если папке есть старые архивы.
rm -rf /tmp/archive_{low,high}.tar.gz > /dev/null 2>&1
#Обнуляем файл лога.
echo "" > nice_log.log

#Определяем процедуры для вызова архивирования с разными приоритетами.
lowpri() {

    echo "[`date`] Start of script with low priority\n" > nice_log.log

    nice -20 tar czvf /tmp/archive_low.tar.gz /boot/* > /dev/null  2>&1

    echo "[`date`] End of script with low priority\n" >> nice_log.log

}

hipri() {

    echo "[`date`] Start of script with high priority\n" >> nice_log.log

    nice --19 tar czvf /tmp/archive_high.tar.gz /boot/* > /dev/null  2>&1

    echo "[`date`] End of script with high priority\n" >> nice_log.log

}
#Запускаем в фоне паралельно 2 процесса архивирования с разными приоритетами
lowpri &
hipri &

cat nice_log.log