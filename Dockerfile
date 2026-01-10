# Base image with PHP and Apache
FROM php:8.2-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev

RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

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

# Configure Apache
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

# Expose port 80
EXPOSE 80
