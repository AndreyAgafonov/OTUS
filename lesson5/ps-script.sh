#!/bin/sh
#Получаем список PID всех запущенных процессов
#pids=$(ls /proc/ |grep ^[0-9])
#сделать по пидам
for i in $(ls /proc/ |grep ^[0-9])
do

#pid[$k]=$(awk '{print $7}' /proc/$i/stat)
#proc[]
#ttylst[$i]=$(awk '{print $7}' /proc/$i/stat)
#pidlst[$i]=$(awk '{print $1}' /proc/$i/stat)
#statlst=
#timeslt=
#cmdlst=
#printf ($pidlst\t,$ttylst\n)
printf "   %s\t" $(awk '{print $1}' /proc/$i/stat)
printf "   %s\t" $(awk '{print $7}' /proc/$i/stat)
printf "   %s\t" $(awk '{print $22}' /proc/$i/stat)
printf "   %s\t" $(awk '{print $3}' /proc/$i/stat)
printf "   %s\n" $(awk '{print $2}' /proc/$i/stat)


#printf "   %d\t" $index
#printf "   %d\n" $index
done