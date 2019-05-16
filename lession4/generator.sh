#!/bin/bash
cd /vagrant
srcip=ips.log
request=request.log



cat nginx_logs.txt | awk -F" " '{print $1}'|uniq -u > $srcip
cat nginx_logs.txt | awk -F"]" '{print $2}'|cut -c 2- >$request

