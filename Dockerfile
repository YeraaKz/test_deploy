# Используем официальный образ PHP с FPM
FROM php:8.1-fpm

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
        nginx \
        git \
        unzip \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        zip \
        curl \
        && apt-get clean && rm -rf /var/lib/apt/lists/*
ENV SKIP_COMPOSER 1

# Устанавливаем PHP расширения
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Устанавливаем Composer

# Копируем исходный код Symfony в контейнер
COPY . /var/www
WORKDIR /var/www

RUN composer install --no-dev --optimize-autoloader
# Устанавливаем зависимости Composer
ENV COMPOSER_ALLOW_SUPERUSER 1

# Копируем конфигурацию nginx в контейнер
COPY nginx.conf /etc/nginx/nginx.conf
COPY symfony.conf /etc/nginx/conf.d/

# Настройка прав доступа
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www

# Открываем порты для nginx и fpm
EXPOSE 80 9000

# Запускаем nginx и PHP-FPM
CMD php-fpm -D && nginx -g 'daemon off;'

