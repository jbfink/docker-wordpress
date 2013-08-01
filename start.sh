#!/bin/bash
/usr/sbin/mysqld & 
sleep 10s
MYSQL_PASSWORD=`pwgen -c -n -1 12`
echo mysql root password: $MYSQL_PASSWORD
echo $MYSQL_PASSWORD > /mysql-root-pw.txt
mysqladmin -u root password $MYSQL_PASSWORD 
killall mysqld
sleep 10s
supervisord -n
