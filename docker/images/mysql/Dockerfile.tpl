FROM mysql:5.6

RUN set -eux ; \
    mkdir -p /home/www-data

RUN set -eux ; \
    groupmod -g __GROUP_ID__ www-data

RUN set -eux ; \
    usermod -u __USER_ID__ -g __GROUP_ID__ www-data

COPY files/init-db.sh /home/www-data/init-db.sh

RUN set -eux ; \
    chown www-data:www-data -R /home/www-data && \
    chmod +x /home/www-data/init-db.sh

WORKDIR /home/www-data
