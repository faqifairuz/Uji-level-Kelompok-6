# Panduan Deployment ke Railway

## Prasyarat

1. Akun Railway (https://railway.app)
2. Git repository Anda sudah ter-push
3. Variabel lingkungan yang diperlukan

## Langkah-langkah Deployment

### 1. Setup Railway CLI (Opsional)

```bash
npm i -g @railway/cli
railway login
```

### 2. Koneksi ke Railway

#### Opsi A: Via GitHub (Recommended)
1. Login ke https://railway.app
2. Klik "New Project" → "Deploy from GitHub"
3. Pilih repository Anda
4. Railway akan otomatis mendeteksi Dockerfile dan build

#### Opsi B: Via Railway CLI
```bash
railway init
railway up
```

### 3. Konfigurasi Environment Variables

Di dashboard Railway, tambahkan variabel berikut:

```env
APP_NAME=YourAppName
APP_KEY=                    # Generate dengan: php artisan key:generate
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-app.railway.app

# Database (PostgreSQL recommended untuk Railway)
DB_CONNECTION=pgsql
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=railway
DB_USERNAME=postgres
DB_PASSWORD=your_password

# Cache & Session
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync

# Mail (optional)
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your_username
MAIL_PASSWORD=your_password
MAIL_FROM_ADDRESS=noreply@example.com

# App specific
LOG_CHANNEL=stack
```

### 4. Setup Database

Jika menggunakan PostgreSQL di Railway:

1. Di Railway dashboard, tambahkan PostgreSQL service
2. Copy connection string ke DB_HOST, DB_DATABASE, DB_USERNAME, DB_PASSWORD
3. Railway akan otomatis menjalankan migrations dari Dockerfile

### 5. Build & Deploy

Railway akan:
1. ✅ Build Docker image
2. ✅ Install PHP & Node dependencies
3. ✅ Build frontend assets dengan Vite
4. ✅ Menjalankan migrations (jika ada)
5. ✅ Start aplikasi

### 6. Monitoring

Kunjungi dashboard Railway untuk:
- View logs: Tab "Logs"
- Monitor resources: Tab "Metrics"
- Check environment variables: Tab "Variables"

## Troubleshooting

### Error: "Service crashed"

1. **Check logs** - Lihat tab Logs untuk detail error
2. **Verify env vars** - Pastikan APP_KEY dan DB credentials sudah benar
3. **Check storage permissions** - Directory `storage` harus writable

```bash
# Lokal (untuk debugging):
docker build -t laravel-app .
docker run -p 80:80 laravel-app
```

### Database tidak migrasi otomatis

Uncomment di Dockerfile untuk auto-migration:
```dockerfile
RUN php artisan migrate --force
```

### File uploads tidak tersimpan

Gunakan cloud storage (S3, Google Cloud, dll):
1. Update `FILESYSTEM_DISK` di .env
2. Tambahkan credentials ke environment variables

## Optimasi Production

### 1. Configure Cache
```env
CACHE_DRIVER=redis
SESSION_DRIVER=redis
REDIS_HOST=localhost
REDIS_PASSWORD=
```

### 2. Enable Opcache
✅ Sudah enabled di docker/php.ini

### 3. Asset Compression
✅ Sudah enabled di nginx.conf (gzip)

### 4. Security Headers
✅ Sudah dikonfigurasi di docker/default.conf

## Custom Domain

1. Di Railway dashboard → Domain
2. Klik "Generate Domain" atau link custom domain
3. Update APP_URL di environment variables
4. Update DNS jika menggunakan custom domain

## Tips Penting

- **Don't commit .env** - Gunakan Railway env vars
- **Use strong APP_KEY** - Generate baru untuk production
- **Enable HTTPS** - Railway otomatis setup SSL
- **Monitor logs** - Set up log alerts jika ada error
- **Scale resources** - Increase CPU/RAM jika perlu performance

## Support

- Railway Docs: https://docs.railway.app
- Laravel Deployment: https://laravel.com/docs/deployment
- Hubungi Railway support jika ada masalah deployment

---

**Dibuat untuk Laravel 12 + Vite + Tailwind**
