#!/bin/bash

php-fpm
php artisan config:cache
php artisan migrate

