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

# Устанавливаем PHP расширения
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Копируем исходный код Symfony в контейнер
COPY . /var/www/symfony

# Устанавливаем зависимости Composer
RUN composer install --no-dev --optimize-autoloader -d /var/www/symfony

# Копируем конфигурацию nginx в контейнер
COPY nginx.conf /etc/nginx/nginx.conf
COPY symfony.conf /etc/nginx/conf.d/

# Настройка прав доступа
RUN chown -R www-data:www-data /var/www/symfony && chmod -R 755 /var/www/symfony

# Открываем порты для nginx и fpm
EXPOSE 80 9000

# Запускаем nginx и PHP-FPM
CMD service php8.1-fpm start && nginx -g 'daemon off;'
