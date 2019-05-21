#!/bin/bash
#===================Varibles==================
LOGFILE=/vagrant/nginx.log
CURRENTDATE='date'
LASTRUN='date'
LOGDIR=/var/log/parser
PIDFILE=

#======================body====================

#count IP 
#count errors
#return code
awk -F"" '{pront $}' |sort -nu
cat nginx.log |awk -F" " '{print $9}'|sort -n |uniq -c

>>