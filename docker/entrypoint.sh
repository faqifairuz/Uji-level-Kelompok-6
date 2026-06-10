#!/bin/sh
set -e

echo "🚀 Starting Laravel application..."

# Ensure all required directories exist
echo "📂 Creating required directories..."
mkdir -p /var/log/supervisor /var/run/supervisor
chmod 755 /var/log/supervisor /var/run/supervisor

# Set proper permissions for Laravel storage
echo "🔐 Setting permissions..."
chmod -R 775 /app/storage /app/bootstrap/cache
chown -R www-data:www-data /app/storage /app/bootstrap/cache 2>/dev/null || true

# Run database migrations if needed (uncomment if auto-migrate desired)
# echo "🗄️  Running migrations..."
# php /app/artisan migrate --force --no-interaction

# Clear caches
echo "🧹 Clearing application caches..."
php /app/artisan config:cache --no-interaction || true
php /app/artisan view:cache --no-interaction || true
php /app/artisan route:cache --no-interaction || true

# Verify PHP-FPM configuration
echo "✅ Validating PHP-FPM configuration..."
php-fpm -t

# Verify Nginx configuration
echo "✅ Validating Nginx configuration..."
nginx -t

# Start Supervisor
echo "🎯 Starting Supervisor (manages PHP-FPM & Nginx)..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
