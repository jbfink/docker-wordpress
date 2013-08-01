FROM ubuntu:latest
MAINTAINER John Fink <john.fink@gmail.com>
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install mysql-client mysql-server apache2 libapache2-mod-php5 pwgen
ADD ./mysql-root-chpw.sh /mysql-root-chpw.sh
RUN chmod 755 /mysql-root-chpw.sh
