#!/bin/bash
set -e

if [ -z "$APP_KEY" ]; then
  echo "Generating APP_KEY..."
  php artisan key:generate --force
fi

# Run migrations (safe on startup)
php artisan migrate --force || true

# Clear/cache
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

exec "$@"
