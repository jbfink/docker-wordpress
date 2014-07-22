#!/bin/bash
function shut_down {

	if [ -z "$WP_DBNAME" ];then
		DBNAME="wordpress"
	else
		DBNAME=$WP_DBNAME
	fi

	echo "Start dumping $DBNAME..."
	mysql -u$WP_USER -pWP_PASSWD $DBNAME > $DUMP_PATH$DUMP_FILENAME

	if [ $? -eq 0 ];then
		echo "Dumping $DBNAME success!"
	else
		echo "Dumping $DBNAME failed!!"
	fi 
	runnig=0
}
echo "Start Script!!"

DUMP_PATH="/var/www/wp-content/dump"
DUMP_FILENAME="dump.sql"
WP_USER="wordpress"
WP_PASSWD="wordpress"
running=1


trap "shut_down" SIGTERM

while true; do
  if [ "$running" = "1" ]; then
    sleep 1
  else
    break
  fi
done
