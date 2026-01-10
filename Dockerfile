FROM php:8.2-apache

ENV COMPOSER_MEMORY_LIMIT=-1

# System + PHP dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip zip \
    libpng-dev libonig-dev libxml2-dev libzip-dev libicu-dev \
    && docker-php-ext-install \
        pdo pdo_mysql mbstring exif pcntl bcmath gd zip intl \
    && apt-get clean

RUN a2enmod rewrite

WORKDIR /var/www/html

# Copy only composer files first
COPY composer.json composer.lock ./

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 🔑 KEY FIX IS HERE
RUN composer install \
    --no-dev \
    --no-scripts \
    --no-interaction \
    --prefer-dist \
    --ignore-platform-reqs

# Copy rest of Laravel app
COPY . .

# Optimize autoloader AFTER code exists
RUN composer dump-autoload --optimize

# Permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Apache config
COPY apache.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
