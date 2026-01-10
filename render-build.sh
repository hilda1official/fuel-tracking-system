#!/bin/bash
set -e

echo "Installing dependencies..."
composer install --no-interaction --prefer-dist --optimize-autoloader

echo "Generating APP_KEY..."
php artisan key:generate --force

echo "Running migrations..."
php artisan migrate --force

echo "Clearing cache..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Build complete!"
