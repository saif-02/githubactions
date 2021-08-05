FROM php:7.3-fpm

WORKDIR /var/www

RUN apt-get update && apt-get -y install git && apt-get -y install zip && apt-get install -y libpng-dev




RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && php composer.phar install --no-dev --no-scripts \
    && rm composer.phar

COPY . /var/www

RUN chown -R www-data:www-data /var/www 
        
RUN chmod -R 775 /var/www 
        
RUN  apt-get install -y libmcrypt-dev \
        libmagickwand-dev --no-install-recommends \
        && pecl install mcrypt-1.0.2 \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-enable mcrypt


RUN php artisan cache:clear \
    && php artisan config:clear \
    && php artisan key:generate
