#!/bin/bash
echo "Запуск развертывания в" `date`
time=$(date +%s)
vagrant status | awk 'BEGIN{ tog=0; } /^$/{ tog=!tog; } /./ { if(tog){print $1} }' | xargs -P6 -I {} vagrant up {} --no-provision
vagrant provision
echo "---"
echo "Затрачено на развертывание " $(($(date +%s)-$time)) " секунд."