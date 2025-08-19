#!/bin/bash

set -e

# Step 1: Fix permissions
echo "🔧 Fixing permissions..."
docker compose exec php chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
docker compose exec php chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Step 2: Copy .env.example if .env doesn't exist
echo "📦 Ensuring .env file exists..."
docker compose exec php sh -c 'if [ ! -f .env ]; then cp .env.example .env; fi'

# Step 3: Generate application key
echo "🔐 Generating app key..."
docker compose exec php php artisan key:generate

# Step 4: Clear & cache configs
echo "⚙️ Caching config..."
docker compose exec php php artisan config:clear
docker compose exec php php artisan config:cache

# Step 5: Run migrations
echo "🧱 Running migrations..."
docker compose exec php php artisan migrate --force

echo "✅ Laravel initialized!"
    