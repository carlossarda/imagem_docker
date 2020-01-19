#!/bin/bash

#iniciando php-fpm
/etc/init.d/php7.4-fpm start

#iniciando nginx
nginx -g "daemon off;"