#!/bin/bash

echo 'Creating Database `ev` ...'
mysql -u root --password="root" -e 'CREATE DATABASE IF NOT EXISTS `ev` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci'
printf "Done\n\n"

mysql -u root --password="root" -e 'SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = "ev"'
