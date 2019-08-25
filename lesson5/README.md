## OTUS.Lesson 5. Работа с процессами
<pre>
Реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice
- Результат ДЗ - скрипт запускающий 2 процесса с разными nice и замеряющий время выполнения и лог консоли
</pre>

Скрипт запускает два задания на архивирование каталога boot один с наивысшим приоритетом, другой с низшим приоритетом.

В лог пишется date пачала выполнения и окончания выполнения команд архивирования.

Как видно по итогам выполнения, команда, имеющаяя более высокий приоритет, выполняется быстрее, даже будучи запущенной второй.

<details>

<summary>nice.sh</code></summary>

```
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
```
</details>


<details>

<summary>nice_log.log</code></summary>

```
[Sun Aug 25 14:14:23 MSK 2019] Start of script with low priority\n

[Sun Aug 25 14:14:23 MSK 2019] Start of script with high priority\n

[Sun Aug 25 14:14:26 MSK 2019] End of script with high priority\n

[Sun Aug 25 14:14:26 MSK 2019] End of script with low priority\n
```

</details>
