#!/bin/bash

DUMP_PATH="/var/www/wp-content/dump"
DUMP_FILENAME="db.sql"
WP_USER="wordpress"
WP_PASSWD="wordpress"
WP_DBNAME="wordpress"

mysql -u$WP_USER -pWP_PASSWD $WP_DBNAME > $DUMP_PATH$DUMP_FILENAME