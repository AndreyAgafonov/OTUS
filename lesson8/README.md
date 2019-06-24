Работа с загрузчиком


Задание:

1. Попасть в систему без пароля [несколькими способами](task1);
2. Установить систему с LVM, после чего [переименовать VG](task2);
3. [Добавить модуль](task3) в initrd.


Дополнительно:

4. Сконфигурировать систему без отдельного раздела с /boot, а только с [LVM](specialtask).

Репозиторий с пропатченым grub: https://yum.rumyantsev.com/centos/7/x86_64/
PV необходимо инициализировать с параметром --bootloaderareasize 1m


Критерии оценки:

Описать действия и описать разницу между методами получения шелла в процессе загрузки.
Где получится - использоватьscript, где не получается - словами или копипастой описать действия.

[Эксперимент](experiment): перенос /boot на отдельный lvm и загрузка с него.