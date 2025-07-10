FROM php:8.4-fpm-alpine

RUN apk add --no-cache \
    # for dev convenience
    bash \
    # for groupmod command
    shadow \
    # for npm installation
    dpkg-dev \
    g++ \
    gcc \
    libc6-compat \
    linux-headers \
    make \
    python3 \
    # for initializing the db
    mysql-client \
    # for dev convenience
    curl ack htop jq vim

RUN apk add --no-cache \
        $PHPIZE_DEPS \
        linux-headers && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug

RUN set -eux ; \
    docker-php-ext-configure pcntl --enable-pcntl && \
    docker-php-ext-install pcntl

RUN set -eux ; \
    docker-php-ext-install pdo pdo_mysql

RUN set -eux ; \
    groupmod -g __GROUP_ID__ www-data

RUN set -eux ; \
    usermod -u __USER_ID__ -g __GROUP_ID__ www-data

RUN set -eux ; \
    chown www-data:www-data -R /home/www-data

RUN set -eux ; \
    cd /home/www-data/ && \
    wget -O composer-setup.php https://getcomposer.org/installer && \
    php composer-setup.php && \
    rm composer-setup.php && \
    mv composer.phar /usr/local/bin/composer

# Install Laravel

USER www-data:www-data

RUN set -eux ; \
    composer global require laravel/installer

USER root

RUN set -eux ; \
    ln -s /home/www-data/.composer/vendor/laravel/installer/bin/laravel /usr/local/bin/laravel

# End

# Install NVM

USER www-data:www-data

RUN set -eux ; \
    wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/__NVM_VERSION__/install.sh" | bash

USER root

COPY files/.nvm/ /home/www-data/.nvm/
RUN set -eux ; \
    chown -R www-data:www-data /home/www-data/.nvm

# End

COPY files/.bashrc /home/www-data/.bashrc
RUN set -eux ; \
    chown www-data:www-data /home/www-data/.bashrc

COPY files/autorun.sh /home/www-data/autorun.sh
RUN set -eux ; \
    chmod ugo+x /home/www-data/autorun.sh ; \
    chown www-data:www-data /home/www-data/autorun.sh

# Store logs in our defined files instead of in Docker logs

RUN set -eux ; \
    sed -i 's/^\(listen.*\)$/;\1\nlisten = \/var\/run\/php\/php-fpm.sock/g' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/^;\(access.log.*\)$/;\1\naccess.log = \/var\/log\/www.access.log/g' /usr/local/etc/php-fpm.d/www.conf

RUN set -eux ; \
    sed -i 's/^\(error_log.*\)$/;\1\nerror_log = \/var\/log\/php-fpm.log/g' /usr/local/etc/php-fpm.d/docker.conf && \
    sed -i 's/^\(access.log.*\)$/;\1\naccess.log = \/var\/log\/access.log/g' /usr/local/etc/php-fpm.d/docker.conf

# End

RUN set -eux ; \
    sed -i -e '$axdebug.mode=develop,coverage,debug,profile' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    sed -i -e '$axdebug.idekey=VSCODE' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    sed -i -e '$axdebug.start_with_request=yes' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    sed -i -e '$axdebug.client_port=9031' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    sed -i -e '$axdebug.client_host=172.17.0.1' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN set -eux ; \
    cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /var/www/html
