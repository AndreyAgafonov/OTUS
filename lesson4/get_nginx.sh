#!/bin/bash

cd /vagrant

rps=$((1 + RANDOM % 100))
#echo $rps
while true
    do
        for ((i=1;i<$rps;i++))
            do
            echo "$(shuf -n 1 ips.log) - - [`date +%d`"/"`date +%h`"/"`date +%G`":"`date +%T`" +0000] "$(shuf -n 1 request.log)" >>nginx.log
        done
    sleep 1
done



