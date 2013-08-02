#!/bin/bash
#mysql has to be started this way as it doesn't work to call from /etc/init.d
/usr/sbin/mysqld & 
sleep 10s
# Here we generate random passwords (thank you pwgen!). The first two are for mysql users, the last batch for random keys in wp-config.php
WORDPRESS_DB="wordpress"
MYSQL_PASSWORD=`pwgen -c -n -1 12`
WORDPRESS_PASSWORD=`pwgen -c -n -1 12`
#This is so the passwords show up in logs. 
echo mysql root password: $MYSQL_PASSWORD
echo wordpress password: $WORDPRESS_PASSWORD
echo $MYSQL_PASSWORD > /mysql-root-pw.txt
echo $WORDPRESS_PASSWORD > /wordpress-db-pw.txt
# *extreme* apologies for the butt ugly line that follows. It works.
# No idea if it will *keep* working if wp-config changes radically between
# versions, but I guess we'll have to see, huh?
cat /var/www/wp-config-sample.php | sed 's/database_name_here/'$WORDPRESS_DB'/' | sed 's/username_here/'$WORDPRESS_DB'/' | sed 's/password_here/'$WORDPRESS_PASSWORD'/' | sed '/\x27AUTH_KEY\x27/s/put\ your\ unique\ phrase\ here/'`pwgen -c -n -1 65`'/' | sed '/\x27SECURE_AUTH_KEY\x27/s/put\ your\ unique\ phrase\ here/'`pwgen -c -n -1 65`'/' | sed '/\x27LOGGED_IN_KEY\x27/s/put\ your\ unique\ phrase\ here/'`pwgen -c -n -1 65`'/' | sed '/\x27NONCE_KEY\x27/s/put\ your\ unique\ phrase\ here/'`pwgen -c -n -1 65`'/' | sed '/\x27AUTH_SALT\x27/s/put\ your\ unique\ phrase\ here/'`pwgen -c -n -1 65`'/'  | sed '/\x27SECURE_AUTH_SALT\x27/s/put\ your\ unique\ phrase\ here/'`pwgen -c -n -1 65`'/'  | sed '/\x27LOGGED_IN_SALT\x27/s/put\ your\ unique\ phrase\ here/'`pwgen -c -n -1 65`'/' | sed '/\x27NONCE_SALT\x27/s/put\ your\ unique\ phrase\ here/'`pwgen -c -n -1 65`'/' > /var/www/wp-config.php

chown www-data:www-data /var/www/wp-config.php
mysqladmin -u root password $MYSQL_PASSWORD 
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD'; FLUSH PRIVILEGES;"
killall mysqld
sleep 10s
supervisord -n
