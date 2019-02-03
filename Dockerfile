FROM ubuntu:latest
LABEL maintainer="John Fink <john.fink@gmail.com>"

# Fri Oct 24 13:09:23 EDT 2014
RUN apt-get update && \
	apt-get -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client mysql-server apache2 && \
	libapache2-mod-php5 pwgen python-setuptools vim-tiny php5-mysql php5-ldap && \
	easy_install supervisor

ADD ./scripts/start.sh /start.sh
ADD ./scripts/foreground.sh /etc/apache2/foreground.sh
ADD ./configs/supervisord.conf /etc/supervisord.conf
ADD ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD https://wordpress.org/latest.tar.gz /wordpress.tar.gz

RUN rm -rf /var/www/ && \
	tar xvzf /wordpress.tar.gz && \
	mv /wordpress /var/www/ && \
	chown -R www-data:www-data /var/www/ && \
	chmod 755 /start.sh && \
	chmod 755 /etc/apache2/foreground.sh && \
	mkdir /var/log/supervisor/

EXPOSE 80
CMD ["/bin/bash", "/start.sh"]
