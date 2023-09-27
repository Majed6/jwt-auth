FROM php:7.4
RUN apt update && apt install -y git zip unzip libzip-dev && docker-php-ext-install zip
COPY .  /jwt-auth
WORKDIR jwt-auth
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_MEMORY_LIMIT=-1 composer install --prefer-dist --no-interaction --no-suggest
RUN COMPOSER_ALLOW_SUPERUSER=1 composer test:ci
