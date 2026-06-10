#!/bin/bash

echo "🔨 Starting build process..."

# Install PHP dependencies
echo "📦 Installing PHP dependencies..."
composer install --no-dev --optimize-autoloader

# Install Node dependencies
echo "📦 Installing Node dependencies..."
npm ci

# Build frontend assets
echo "🎨 Building Vite assets..."
npm run build

# Generate Laravel app key if not exists
echo "🔑 Checking APP_KEY..."
if [ -z "$APP_KEY" ]; then
    echo "⚠️  APP_KEY not set, generating..."
    php artisan key:generate
fi

# Clear caches
echo "🧹 Clearing caches..."
php artisan config:cache
php artisan view:cache
php artisan route:cache

# Create necessary directories
echo "📂 Creating storage directories..."
mkdir -p storage/logs
mkdir -p storage/framework/cache
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p bootstrap/cache

# Set permissions
chmod -R 775 storage bootstrap/cache

echo "✅ Build completed successfully!"
