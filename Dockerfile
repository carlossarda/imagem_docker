FROM ubuntu:latest

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#instalando nginx
RUN apt update && apt install -y nginx
RUN rm -rf /var/www/html/*
ADD vhost.conf /etc/nginx/sites-available/default

#configurando timzone
RUN apt install -y tzdata
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#instalando php 8.1
#RUN apt install -y software-properties-common/bionic-updates && apt install -y apt-utils && apt-add-repository -y ppa:ondrej/php
RUN apt update
RUN apt install -y php8.1 php8.1-fpm

#instalando módulos
RUN apt install -y php-pear php8.1-curl php8.1-dev php8.1-gd php8.1-mbstring php8.1-zip php8.1-mysql php8.1-xml php8.1-soap php-xdebug php-igbinary
RUN apt install -y composer git
RUN apt install -y libmcrypt-dev
RUN pecl install mcrypt
RUN composer global require laravel/installer
ADD php.ini /etc/php/8.1/fpm/php.ini
ADD www.conf /etc/php/8.1/fpm/pool.d/www.conf

#instalando módulos diversos
RUN apt update
RUN apt install -y npm nano net-tools iputils-ping
RUN apt-get clean
RUN composer clear-cache

#montando volume dos arquivos web
VOLUME [ "/var/www/html/" ]
RUN chmod -R 777 /var/www/

#script para iniciar serviços
ADD start.sh /start.sh

EXPOSE 80

STOPSIGNAL SIGTERM
CMD ["/bin/bash","/start.sh"]