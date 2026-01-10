FROM php:8.2-apache

# Avoid composer memory issues
ENV COMPOSER_MEMORY_LIMIT=-1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip zip \
    libpng-dev libonig-dev libxml2-dev libzip-dev libicu-dev \
    && docker-php-ext-install \
        pdo pdo_mysql mbstring exif pcntl bcmath gd zip intl \
    && apt-get clean

# Enable Apache rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy composer files FIRST (important for caching & stability)
COPY composer.json composer.lock ./

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP dependencies (NO scripts yet)
RUN composer install \
    --no-dev \
    --no-scripts \
    --no-interaction \
    --prefer-dist

# Copy the rest of the Laravel project
COPY . .

# Run composer scripts AFTER files exist
RUN composer dump-autoload --optimize

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Apache config
COPY apache.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
