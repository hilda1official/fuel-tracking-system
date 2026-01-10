# Use PHP 8.2 with Apache
FROM php:8.2-apache

# Set Composer memory limit
ENV COMPOSER_MEMORY_LIMIT=-1

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev libzip-dev && \
    docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy Laravel project files
COPY . .

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Set folder permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Configure Apache to point to Laravel's public folder
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

# Expose port 80
EXPOSE 80
