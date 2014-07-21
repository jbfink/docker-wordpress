#!/bin/bash

if [ ! -f /var/www/wp-config.php ]; then
#let's create a user to ssh into
SSH_USERPASS=`pwgen -c -n -1 8`
mkdir /home/user
useradd -G sudo -d /home/user user
chown user /home/user
echo user:$SSH_USERPASS | chpasswd
echo ssh user password: $SSH_USERPASS
#mysql has to be started this way as it doesn't work to call from /etc/init.d
/usr/bin/mysqld_safe & 
sleep 10s
# The first two are for mysql users, the last batch for random keys in wp-config.php
if [ -z "$WP_DBNAME" ]; then
	WORDPRESS_DB="wordpress"
else
	WORDPRESS_DB=$WP_DBNAME
fi


MYSQL_PASSWORD="root"
WORDPRESS_PASSWORD="wordpress"
#This is so the passwords show up in logs. 
echo mysql root password: $MYSQL_PASSWORD
echo wordpress password: $WORDPRESS_PASSWORD
echo $MYSQL_PASSWORD > /mysql-root-pw.txt
echo $WORDPRESS_PASSWORD > /wordpress-db-pw.txt
#there used to be a huge ugly line of sed and cat and pipe and stuff below,
#but thanks to @djfiander's thing at https://gist.github.com/djfiander/6141138
#there isn't now.

sed -e "s/database_name_here/$WORDPRESS_DB/
s/username_here/wordpress/
s/password_here/$WORDPRESS_PASSWORD/
/'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
s/wp_/wp_$WORDPRESS_DB/
/'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /var/www/wp-config-sample.php > /var/www/wp-config.php

mv /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.orig
sed "s/upload_max_filesize = 2M/upload_max_filesize = 20M/" /etc/php5/apache2/php.ini.orig > /etc/php5/apache2/php.ini

 

chown www-data:www-data /var/www/wp-config.php
mysqladmin -u root password $MYSQL_PASSWORD 
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE $WORDPRESS_DB; GRANT ALL PRIVILEGES ON $WORDPRESS_DB.* TO 'wordpress'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD'; FLUSH PRIVILEGES;"
#Load dumped db
mysql -uwordpress -p$WORDPRESS_PASSWORD $WORDPRESS_DB < /var/www/wp-content/dump/dump.sql
killall mysqld
sleep 10s
fi
ln -s /etc/dump_db.sh /etc/init.d/dump_db.sh
chmod 755 /etc/init.d/dump_db.sh
update-rc.d dump_db.sh start 20 0 6 .
chown -R www-data:www-data /var/www/
supervisord -n
