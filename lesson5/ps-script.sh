#!/bin/sh
pidlst=$(ls /proc/ |grep ^[0-9])
#echo $pidlst
for i in $pidlst
do
awk '{print $1 $2 }' /proc/$i/stat
done