# Docker Setup & Local Testing

## Prerequisites

- Docker Desktop installed (https://www.docker.com/products/docker-desktop)
- Docker running on your machine

## Quick Start - Local Testing

### 1. Build Docker Image

```bash
docker build -t laravel-app .
```

Or menggunakan docker-compose:

```bash
docker-compose build
```

### 2. Run dengan Docker Compose (Recommended)

```bash
docker-compose up -d
```

Aplikasi akan berjalan di: http://localhost

### 3. Run Database Migrations

```bash
# Jika belum otomatis berjalan
docker-compose exec app php artisan migrate
```

### 4. Generate APP_KEY (jika belum)

```bash
docker-compose exec app php artisan key:generate
```

### 5. View Logs

```bash
docker-compose logs -f app
```

### 6. Akses MySQL

```bash
docker-compose exec mysql mysql -u root -p laravel

# Password: password (default di docker-compose.yml)
```

### 7. Stop Services

```bash
docker-compose down
```

## Manual Docker Commands

Jika tidak ingin menggunakan docker-compose:

```bash
# Build image
docker build -t laravel-app .

# Create network
docker network create app-network

# Run MySQL
docker run --name laravel-mysql \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=laravel \
  -p 3306:3306 \
  -v mysql_data:/var/lib/mysql \
  --network app-network \
  -d mysql:8.0

# Run Laravel app
docker run --name laravel-app \
  -p 80:80 \
  -e DB_HOST=laravel-mysql \
  -e DB_DATABASE=laravel \
  -e DB_USERNAME=root \
  -e DB_PASSWORD=password \
  -e APP_KEY=base64:JMlYC1S9eFfpcM5kDu7FhSBqBVLvvOOV3JhVV9Hkq3o= \
  --network app-network \
  -v $(pwd):/app \
  -d laravel-app
```

## Common Issues

### Port 80 already in use

```bash
# Change port in docker-compose.yml
ports:
  - "8080:80"  # Akses via http://localhost:8080

# Or kill existing process
# Windows: netstat -ano | findstr :80
# Linux/Mac: lsof -i :80
```

### Permission denied (storage/logs)

```bash
docker-compose exec app chmod -R 775 storage bootstrap/cache
```

### Database connection refused

```bash
# Check if MySQL is running
docker-compose ps

# Restart MySQL
docker-compose restart mysql
```

### Image build fails

```bash
# Clean up dan rebuild
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

## Exec Commands in Running Container

```bash
# Run artisan commands
docker-compose exec app php artisan tinker
docker-compose exec app php artisan seed
docker-compose exec app php artisan cache:clear

# Run composer
docker-compose exec app composer update

# Run npm
docker-compose exec app npm run build
```

## Development Mode

Untuk development dengan hot reload:

Edit docker-compose.yml:
```yaml
environment:
  - APP_ENV=local
  - APP_DEBUG=true
```

Lalu rebuild:
```bash
docker-compose down
docker-compose build
docker-compose up -d
```

## Testing Image Before Railway Deployment

```bash
# Build optimized production image
docker build -t laravel-app:prod .

# Run dan test
docker run -p 80:80 \
  -e APP_KEY=base64:YOUR_KEY_HERE \
  -e DB_CONNECTION=mysql \
  laravel-app:prod

# Check response
curl http://localhost
```

## Cleanup

```bash
# Remove containers
docker-compose down

# Remove volumes (WARNING: deletes data)
docker-compose down -v

# Remove images
docker rmi laravel-app

# Clean system
docker system prune -a
```

---

**Tips:**
- Selalu test locally dengan Docker sebelum push ke Railway
- Gunakan `.env.example` untuk konfigurasi default
- Check Docker logs jika ada error: `docker-compose logs -f`
