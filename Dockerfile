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
COPY ./ /var/www
WORKDIR /var/www

# Установка зависимостей через Composer
RUN composer clear-cache
RUN composer install --no-dev --optimize-autoloader

# Настройка прав доступа
RUN chown -R www-data:www-data /var/www/symfony

# Запуск Nginx и PHP-FPM при старте контейнера
CMD service nginx start && php-fpm

# Открытие портов
EXPOSE 80
