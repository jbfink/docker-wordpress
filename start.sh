#!/bin/bash
#mysql has to be started this way as it doesn't work to call from /etc/init.d
/usr/sbin/mysqld & 
sleep 10s
# Here we generate random passwords (thank you pwgen!). The first two are for mysql users, the last batch for random keys in wp-config.php
MYSQL_PASSWORD=`pwgen -c -n -1 12`
WORDPRESS_PASSWORD=`pwgen -c -n -1 12`
AUTH_KEY=`pwgen -sy -1 65`
SECURE_AUTH_KEY=`pwgen -sy -1 65`
LOGGED_IN_KEY=`pwgen -sy -1 65`
NONCE_KEY=`pwgen -sy -1 65`
AUTH_SALT=`pwgen -sy -1 65`
SECURE_AUTH_SALT=`pwgen -sy -1 65`
LOGGED_IN_SALT=`pwgen -sy -1 65`
NONCE_SALT=`pwgen -sy -1 65`
#This is so the passwords show up in logs. 
echo mysql root password: $MYSQL_PASSWORD
echo wordpress password: $WORDPRESS_PASSWORD
echo $MYSQL_PASSWORD > /mysql-root-pw.txt
echo $WORDPRESS_PASSWORD > /wordpress-db-pw.txt
mysqladmin -u root password $MYSQL_PASSWORD 
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD'; FLUSH PRIVILEGES;"
killall mysqld
sleep 10s
supervisord -n
