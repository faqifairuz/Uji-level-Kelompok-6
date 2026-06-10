#!/bin/sh
set -e

# Railway uses $PORT environment variable - default to 8080 if not set
export PORT=${PORT:-8080}

echo "🚀 Starting Laravel application on port $PORT..."

# Ensure all required directories exist
echo "📂 Creating required directories..."
mkdir -p /var/log/supervisor /var/run/supervisor /var/log/nginx
chmod 755 /var/log/supervisor /var/run/supervisor /var/log/nginx

# Substitute PORT into nginx config
echo "⚙️  Configuring Nginx for port $PORT..."
export NGINX_PORT=$PORT
sed -i "s|\${NGINX_PORT}|$NGINX_PORT|g" /etc/nginx/conf.d/default.conf

# Set proper permissions for Laravel storage
echo "🔐 Setting permissions..."
chmod -R 775 /app/storage /app/bootstrap/cache
chown -R www-data:www-data /app/storage /app/bootstrap/cache 2>/dev/null || true

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

# Start Supervisor (will manage PHP-FPM and Nginx)
echo "🎯 Starting Supervisor..."
echo "📡 Application will listen on port $PORT"
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
