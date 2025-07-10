FROM httpd:2.4-alpine

RUN set -eux ; \
    apk add --no-cache \
    # for dev convenience
    bash \
    # for groupmod command
    shadow \
    # for dev convenience
    vim

RUN set -eux ; \
    groupmod -g __GROUP_ID__ www-data

RUN set -eux ; \
    usermod -u __USER_ID__ -g __GROUP_ID__ www-data

RUN set -eux ; \
    chown www-data:www-data -R /home/www-data

RUN set -eux ; \
    cd /usr/local/apache2/logs/ && \
    touch access_log error_log

RUN set -eux ; \
    cd /usr/local/apache2/ && \
    chown www-data:www-data logs && \
    cd logs && \
    chown www-data:www-data access_log error_log

RUN set -eux ; \
    mkdir -p /var/www/html && \
    chown www-data:www-data /var/www/html && \
    chmod 1777 /var/www/html

RUN set -eux ; \
    sed -i "/Listen/s/^/#/g" /usr/local/apache2/conf/httpd.conf && \
    sed -i "/LoadModule proxy_module/s/^#//g" /usr/local/apache2/conf/httpd.conf && \
    sed -i "/LoadModule proxy_fcgi_module/s/^#//g" /usr/local/apache2/conf/httpd.conf && \
    sed -i "/LoadModule rewrite_module/s/^#//g" /usr/local/apache2/conf/httpd.conf && \
    sed -i "/#ServerName/s/$/\\nServerName 127.0.0.1:80/g" /usr/local/apache2/conf/httpd.conf && \
    sed -i 's/^\(DocumentRoot "\/usr\/local\/apache2\/htdocs".*\)$/#\1\nDocumentRoot "\/var\/www\/html"/g' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's/^\(<Directory "\/usr\/local\/apache2\/htdocs">.*\)$/#\1\n<Directory "\/var\/www\/html">/g' /usr/local/apache2/conf/httpd.conf && \
    sed -i "/httpd-vhosts.conf/s/^#//g" /usr/local/apache2/conf/httpd.conf

COPY files/httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
