#!/bin/bash

source "`realpath $(dirname $0)`/config"

function abort_on_error {
    if [ $1 -ne 0 ]; then
        echo "ABORT[$1]"

        if [ ! -z "$2" ]; then
            cd $2
        fi

        exit $1
    fi
}

function build {
    local CWD=`pwd`
    local RET=0

    cd $DOCKER_IMAGE_MYSQL_PATH
    cat Dockerfile.tpl | sed "s|__DOCKER_IMAGE_MYSQL_PATH__|$DOCKER_IMAGE_MYSQL_PATH|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    cat Dockerfile.tmp | sed "s|__USER_ID__|$(id -u)|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    cat Dockerfile.tmp | sed "s|__GROUP_ID__|$(id -g)|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    rm Dockerfile.tmp
    docker build -t $DOCKER_IMAGE_MYSQL . $@

    abort_on_error $? $CWD

    cd $DOCKER_IMAGE_PHP_PATH
    cat Dockerfile.tpl | sed "s|__DOCKER_IMAGE_PHP_PATH__|$DOCKER_IMAGE_PHP_PATH|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    cat Dockerfile.tmp | sed "s|__USER_ID__|$(id -u)|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    cat Dockerfile.tmp | sed "s|__GROUP_ID__|$(id -g)|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    cat Dockerfile.tmp | sed "s|__NVM_VERSION__|$NVM_VERSION|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    cat Dockerfile.tmp | sed "s|__NODE_VERSION__|$NODE_VERSION|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    rm Dockerfile.tmp
    docker build -t $DOCKER_IMAGE_PHP . $@

    abort_on_error $? $CWD

    cd $DOCKER_IMAGE_APACHE_PATH
    cat Dockerfile.tpl | sed "s|__DOCKER_IMAGE_APACHE_PATH__|$DOCKER_IMAGE_APACHE_PATH|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    cat Dockerfile.tmp | sed "s|__USER_ID__|$(id -u)|" > Dockerfile
    cat Dockerfile > Dockerfile.tmp
    cat Dockerfile.tmp | sed "s|__GROUP_ID__|$(id -g)|" > Dockerfile
    rm Dockerfile.tmp
    docker build -t $DOCKER_IMAGE_APACHE . $@

    abort_on_error $? $CWD

    cd $CWD
    echo "DONE"
}

function clean {
    for i in `docker images | grep "$DOCKER_IMAGE_BASE_NAME/" | cut -d' ' -f1`; do
        docker rmi $i $@;
    done

    for ARG in $@; do
        if [[ "$ARG" =~ '--wipe-logs' ]]; then
            rm -rf $LOGS_MYSQL_PATH/* $LOGS_MYSQL_PATH
            rm -rf $LOGS_PHP_PATH/* $LOGS_PHP_PATH
            rm -rf $LOGS_APACHE_PATH/* $LOGS_APACHE_PATH

            echo 'Logs wiped.'
        fi

        if [[ "$ARG" =~ '--wipe-files' ]]; then
            rm -rf $MYSQL_PATH/*
            rm -rf $PHP_PATH/*

            echo 'Files wiped.'
        fi
    done
}

function generate_docker_compose_yml {
    local BASE_SERVICE_NAME=${DOCKER_IMAGE_BASE_NAME//\//-}

    cat $DOCKER_PATH/docker-compose.tpl.yml > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__HOME_PATH__|$HOME_PATH|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__BASE_SERVICE_NAME__|$BASE_SERVICE_NAME|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__DOCKER_IMAGE_APACHE__|$DOCKER_IMAGE_APACHE|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__DOCKER_IMAGE_APACHE_PATH__|$DOCKER_IMAGE_APACHE_PATH|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__DOCKER_IMAGE_MYSQL__|$DOCKER_IMAGE_MYSQL|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__DOCKER_IMAGE_PHP__|$DOCKER_IMAGE_PHP|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__DOCKER_IMAGE_PHP_PATH__|$DOCKER_IMAGE_PHP_PATH|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__LOGS_APACHE_PATH__|$LOGS_APACHE_PATH|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__LOGS_MYSQL_PATH__|$LOGS_MYSQL_PATH|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__LOGS_PHP_PATH__|$LOGS_PHP_PATH|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__MYSQL_PATH__|$MYSQL_PATH|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__PHP_PATH__|$PHP_PATH|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__DOCKER_PORT_APACHE__|$DOCKER_PORT_APACHE|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__DOCKER_PORT_MYSQL__|$DOCKER_PORT_MYSQL|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    cat $DOCKER_PATH/docker-compose.yml | sed "s|__DOCKER_PORT_PHP__|$DOCKER_PORT_PHP|" > $DOCKER_PATH/docker-compose.yml.tmp
    cat $DOCKER_PATH/docker-compose.yml.tmp > $DOCKER_PATH/docker-compose.yml

    rm $DOCKER_PATH/docker-compose.yml.tmp
}

function generate_log_files {
    mkdir -p $LOGS_MYSQL_PATH
    mkdir -p $LOGS_PHP_PATH
    mkdir -p $LOGS_APACHE_PATH

    touch $LOGS_MYSQL_PATH/mysqld.log

    touch $LOGS_PHP_PATH/php-fpm.log
    touch $LOGS_PHP_PATH/access.log
    touch $LOGS_PHP_PATH/www.access.log

    touch $LOGS_APACHE_PATH/access_log
    touch $LOGS_APACHE_PATH/error_log
}

if [ "$1" == "build" ]; then
    build "${@:2}"

    generate_docker_compose_yml

    exit 0
fi

if [ "$1" == "clean" ]; then
    clean "${@:2}"

    exit 0
fi

if [ "$1" == "up" ]; then
    # setup

    generate_docker_compose_yml
    generate_log_files

    USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose -f $DOCKER_PATH/docker-compose.yml up -d

    abort_on_error $?

    exit 0
fi

if [ "$1" == "down" ]; then
    USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose -f $DOCKER_PATH/docker-compose.yml down

    abort_on_error $?

    exit 0
fi

echo "Commands:"
echo "    build     Build Docker images"
echo "    clean     Remove Docker images"
echo "    up        Start all Docker containers"
echo "    down      Stop all Docker containers"
