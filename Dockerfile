FROM ubuntu:latest
MAINTAINER John Fink <john.fink@gmail.com>
RUN apt-get update # Mon Jan 27 11:35:22 EST 2014
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client mysql-server apache2 libapache2-mod-php5 pwgen python-setuptools vim-tiny php5-mysql openssh-server sudo php5-ldap
# for cloudfuse
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential libcurl4-openssl-dev libxml2-dev libssl-dev libfuse-dev git fuse libfuse2
#ADD ./.cloudfuse /var/www/.cloudfuse
ADD ./cloudfuse-make.sh /cloudfuse-make.sh
RUN mkdir /cloudfuse
RUN git clone https://github.com/redbo/cloudfuse /cloudfuse
RUN /bin/bash /cloudfuse-make.sh
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
ADD ./.cloudfuse /var/www/.cloudfuse
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN mkdir /var/log/supervisor/
RUN mkdir /var/run/sshd
RUN su www-data -c "mkdir /var/www/wp-content/uploads"
#RUN echo "cloudfuse /var/www/files fuse uid=1000,gid=1000,umask=0111 0 0" >> /etc/fstab
EXPOSE 80
EXPOSE 22
CMD ["/bin/bash", "/start.sh"]
