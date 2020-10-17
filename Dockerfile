FROM php:7.3.6-fpm-alpine3.9

RUN apk add --no-cache shadow
RUN apk add bash mysql-client
RUN docker-php-ext-install pdo pdo_mysql
RUN apk add --no-cache openssl


RUN apk add --no-cache bash mysql-client libxml2-dev libzip-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev gmp-dev autoconf openssl-dev g++ make 
RUN docker-php-ext-install pdo pdo_mysql

# Install soap extention
RUN docker-php-ext-install soap

# Install posix extention
RUN docker-php-ext-install posix

# Install for image manipulation
RUN docker-php-ext-install exif

# Install the PHP pcntl extention
RUN docker-php-ext-install pcntl

# Install the PHP zip extention
RUN docker-php-ext-install zip

# Install the PHP bcmath extension
RUN docker-php-ext-install bcmath

# Install the PHP gmp extention
RUN docker-php-ext-install gmp


RUN pecl install mongodb && docker-php-ext-enable mongodb

RUN pecl install redis && docker-php-ext-enable redis


ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN rm -rf /usr/local/etc/php-fpm.d/ww.conf
COPY ./www.conf /usr/local/etc/php-fpm.d/

WORKDIR /var/www
RUN rm -rf /var/www/html

COPY . /var/www
RUN ln -s public html

#RUN chown -R www-data:www-data /var/www
#RUN usermod -u 1000 www-data
#USER www-data

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN cp -p /usr/local/bin/composer /var/www
RUN chmod +x /var/www/composer

RUN composer install

#COPY ./.env .
RUN php artisan key:generate
RUN php artisan config:cache



EXPOSE 9000

ENTRYPOINT [ "php-fpm" ]