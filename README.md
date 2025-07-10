# S30 Laravel + ReactJS Test 2022.04

## Requirements

This project requires only two dependencies:

 - [Docker](https://docs.docker.com/engine/install/)
 - [Docker Compose](https://docs.docker.com/compose/install/)

Other dependencies are all automatically installed within the docker containers.

## Setup

### Download

Clone the [repo](https://github.com/woozykoi/ev) from Github.

    git clone https://github.com/woozykoi/ev.git

> NOTE: This may take a while, depending on your network connection/speed. The issue is due to the inclusion of the `node` executable. Since compiling it each time the docker image is re-built can take a long time, I've decided to just include the executable.

### Initial Config

Go to the `ev` directory, open the `docker/config` file, and make the changes as needed.

    cd ev
    vim docker/config # use any editor you prefer

Some values you might change (eg, already in use by existing resources/services/etc.):

 - `DOCKER_IMAGE_BASE_NAME` : This is what will be used as part of the docker resource name, eg, `loy-ev` => `docker-loy-ev-php-1`.
 - `DOCKER_PORT_APACHE` : Port to access the site, eg, `9004` => `localhost:9004`.
 - `DOCKER_PORT_MYSQL` : Port to access the Mysql server if you want to access it with your client, eg, `9001` => `localhost:9001`.
 - `DOCKER_PORT_PHP` : Port used by PHP-FPM, though only useful to Apache.

> NOTE: For the rest of this document, `DOCKER_IMAGE_BASE_NAME` is `loy-ev`.

### Build Docker Images

Run the build command.

    docker/cmd.sh build

> NOTE: `cmd.sh` can be executed from any directory.

On first run, this can take a while as it pulls the [httpd](https://hub.docker.com/_/httpd), [mysql](https://hub.docker.com/_/mysql) and [php](https://hub.docker.com/_/php) docker images.
In addition, it also sets up the additional dependencies (eg, Composer, NVM, etc.).

If the build process fails, check the logs.
Sometimes the issue is due to intermittent events, such as network timeout, rate limit, etc.
In such cases, run the build command again.

### Run The Docker Containers

Run the up command to build, create, and start the Docker containers.

    docker/cmd.sh up

Optionally, check that all three Docker containers are up and running (eg, `docker-loy-ev-apache-1`, `docker-loy-ev-php-1`, and `docker-loy-ev-mysql-1`).

    docker container ls

### Initialize The Database

Enter the Mysql Docker container.

    docker exec -it docker-loy-ev-mysql-1 bash

Execute the bash script `init-db.sh`.

    /home/www-data/init-db.sh

It should show the `ev` database under the `SCHEMA_NAME` column.

Exit the Docker container.

    exit

### Initialize The Rest

Enter the PHP Docker container.

    docker exec --user www-data:www-data -it docker-loy-ev-php-1 bash

> NOTE: The `www-data` user/group will have the same user/group ids as your host OS user/group, allowing for seamless access by you and PHP in the Docker container.

Update the `.env` file, either from the host OS, or within the Docker container.

    cd /var/www/html
    vim .env

Value the you might need to change:

- `DB_HOST` : This should be the Docker gateway IP [1].
- `DB_PORT` : This should match the earlier `DOCKER_PORT_MYSQL` in `docker/config`.

> NOTE: [1] To determine the Docker gateway, run the command in your host OS terminal: `ifconfig`. Look for the `docker0` entry, and the `inet` under it.

Install the Laravel vendors.

    composer install

Run the database migration.

    php artisan migrate

Install the Node modules.

    npm install

Build the assets.

    npm run dev

Exit the Docker container.

    exit

### Access The Site

In your browser, go to the URL: http://localhost:9004.

### Clean Up

When done, stop the Docker containers.

    docker/cmd.sh down

Remove the Docker images.

    docker/cmd.sh clean -f
