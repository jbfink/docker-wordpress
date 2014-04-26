FROM ubuntu:latest
MAINTAINER John Fink <john.fink@gmail.com>
RUN apt-get update # Mon Jan 27 11:35:22 EST 2014
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client mysql-server apache2 libapache2-mod-php5 pwgen python-setuptools vim-tiny php5-mysql openssh-server sudo php5-ldap
RUN easy_install supervisor
ADD ./scripts/start.sh /start.sh
ADD ./scripts/foreground.sh /etc/apache2/foreground.sh
ADD ./configs/supervisord.conf /etc/supervisord.conf
ADD ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN echo %sudo	ALL=NOPASSWD: ALL >> /etc/sudoers
RUN rm -rf /var/www/
ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz
RUN tar xvzf /wordpress.tar.gz 
RUN mv /wordpress /var/www/
RUN chown -R www-data:www-data /var/www/
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN mkdir /var/log/supervisor/
RUN mkdir /var/run/sshd
EXPOSE 80
EXPOSE 22
CMD ["/bin/bash", "/start.sh"]
