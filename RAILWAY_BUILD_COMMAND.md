# Railway Custom Build Command

Berikut adalah command yang harus Anda masukkan di Railway dashboard untuk custom build command.

## 📍 Lokasi di Railway

Dashboard → Project → Service Settings → Build tab → **Build Command** field

## ✅ Build Command Options

### Option 1: Standard Build (Recommended)

```bash
composer install --no-dev --optimize-autoloader && npm ci && npm run build && php artisan config:cache && php artisan view:cache && php artisan route:cache
```

**Yang dilakukan:**
- ✅ Install PHP dependencies (production only)
- ✅ Install Node dependencies
- ✅ Build Vite assets
- ✅ Cache Laravel config, views, dan routes
- ❌ Tidak run migrations (safer, bisa manual)

---

### Option 2: With Database Migrations (Recommended jika first deploy)

```bash
composer install --no-dev --optimize-autoloader && npm ci && npm run build && php artisan migrate --force && php artisan config:cache && php artisan view:cache && php artisan route:cache
```

**Tambahan:**
- ✅ Auto run database migrations
- ⚠️ Hanya untuk first deployment, disable setelah

---

### Option 3: Full Build (Dev Mode - Not Recommended for Production)

```bash
composer install && npm ci && npm run build && php artisan key:generate && php artisan migrate --force && php artisan config:cache && php artisan view:cache && php artisan route:cache
```

**Untuk development/testing saja**

---

## 🎯 Recommended Setup

### First Time Deploy:

1. Set Build Command:
```bash
composer install --no-dev --optimize-autoloader && npm ci && npm run build && php artisan migrate --force && php artisan config:cache && php artisan view:cache && php artisan route:cache
```

2. Setelah deploy berhasil, remove `php artisan migrate --force` untuk prevent accidental data issues

### Subsequent Deploys:

```bash
composer install --no-dev --optimize-autoloader && npm ci && npm run build && php artisan config:cache && php artisan view:cache && php artisan route:cache
```

---

## 🔒 Alternative: Menggunakan Build Script

Jika command terlalu panjang, bisa gunakan script:

**Build Command:**
```bash
bash railway-build.sh
```

Script sudah tersedia di `railway-build.sh`

---

## 📋 Step-by-Step di Railway Dashboard

1. **Login ke railway.app**
2. **Buka Project** → Pilih service Laravel Anda
3. **Tab "Settings"** → scroll ke **"Build Command"**
4. **Paste** salah satu command dari option di atas
5. **Save** (jika ada tombol)
6. **Trigger Deploy** - bisa dengan push ke GitHub atau manual redeploy

---

## ✨ Build Output

Saat build berjalan, Anda akan lihat logs:

```
📦 Installing PHP dependencies...
📦 Installing Node dependencies...
🎨 Building Vite assets...
🧹 Clearing caches...
✅ Build completed successfully!
```

---

## ⚠️ Troubleshooting

### Build fails - "npm not found"
**Solusi:** Railway detect Node.js dari `package.json` - pastikan ada di root directory ✅

### Build fails - "composer not found"
**Solusi:** Railway auto-detect PHP dari `composer.json` - pastikan ada ✅

### Migrations tidak jalan
**Solusi:** Database belum ter-link atau environment variables salah
- Check `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`
- Pastikan database service sudah linked

### Assets tidak build
**Solusi:** Pastikan `npm run build` command ada di `package.json`
```json
{
  "scripts": {
    "build": "vite build"
  }
}
```

---

## 📊 Recommended Build Command untuk Production

**Copy & paste ini:**

```bash
composer install --no-dev --optimize-autoloader && npm ci && npm run build && php artisan config:cache && php artisan view:cache && php artisan route:cache
```

---

**✅ Ready to deploy!** Tinggal copy command ke Railway dashboard.
