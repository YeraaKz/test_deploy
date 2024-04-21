# Базовый образ
FROM php:8.1-fpm

# Установка зависимостей
RUN apt-get update && apt-get install -y nginx git unzip libicu-dev libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql intl opcache gd

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Конфигурация Nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY symfony.conf /etc/nginx/sites-available/default

# Копирование исходного кода приложения
WORKDIR /var/www
COPY ./ /var/www

# Установка зависимостей через Composer
RUN composer clear-cache
#RUN composer install --no-dev --optimize-autoloader


# Запуск Nginx и PHP-FPM при старте контейнера


# Открытие портов
EXPOSE 80 9000

CMD service nginx start && php-fpm