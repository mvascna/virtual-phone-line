FROM php:7.3-apache

ENV PHP_INI_PATH "/usr/local/etc/php/php.ini"

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_mysql

RUN echo "log_errors = On" >> ${PHP_INI_PATH} && \
    echo "error_reporting = E_ALL" >> ${PHP_INI_PATH} && \
    echo "error_log=/dev/stderr" >> ${PHP_INI_PATH}

RUN a2enmod rewrite expires

RUN curl -L https://github.com/hairyhenderson/gomplate/releases/download/v3.6.0/gomplate_linux-amd64 -o gomplate && \
    chmod +x gomplate && \
    mv gomplate /usr/local/bin/gomplate

RUN curl -L https://github.com/bmlt-enabled/yap/releases/download/3.6.5-beta19/yap-3.6.5-beta19.zip -o yap.zip && \
    unzip yap.zip -d /var/www/html && \
    rm -f yap.zip

COPY config.php /tmp/config.php
COPY startup.sh /tmp/startup.sh

CMD ["/tmp/startup.sh"]
