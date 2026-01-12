FROM php:8.2-fpm

WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    zip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    nodejs \
    npm \
    && docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ 2>/dev/null || true \
    && docker-php-ext-install -j$(nproc) pdo_mysql mbstring bcmath gd xml zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy manifest files first for caching
COPY composer.json composer.lock ./
COPY package.json ./
COPY package-lock.json* ./

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Install Node dependencies and build assets
RUN npm ci --prefer-offline --no-audit && npm run build

# Copy application
COPY . .

# Ensure storage and cache dirs exist with correct permissions
RUN mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Add entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["php", "-S", "0.0.0.0:${PORT:-8000}", "-t", "public"]
