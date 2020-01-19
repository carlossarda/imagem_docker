FROM ubuntu:latest

#instalando nginx
RUN apt update && apt install -y nginx
RUN rm -rf /var/www/html/*
ADD vhost.conf /etc/nginx/sites-available/default

#configurando timzone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y tzdata
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#instalando php 7.4
RUN apt install -y software-properties-common/bionic-updates && apt install -y apt-utils && apt-add-repository -y ppa:ondrej/php
RUN apt update
RUN apt install -y php7.4 php7.4-fpm

#instalando módulos
RUN apt install -y php-pear php7.4-curl php7.4-dev php7.4-gd php7.4-mbstring php7.4-zip php7.4-mysql php7.4-xml
RUN apt install -y composer git
RUN composer global require laravel/installer
ADD php.ini /etc/php/7.4/fpm/php.ini
ADD www.conf /etc/php/7.4/fpm/pool.d/www.conf

#instalando módulos diversos
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