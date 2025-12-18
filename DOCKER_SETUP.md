# ⚠️ IMPORTANT - Read This First!

## What Runs Where?

✅ **MySQL** → Runs in Docker (container)
✅ **Laravel** → Runs locally on your computer (NOT in Docker)

## Quick Start

```bash
# 1. Start ONLY MySQL in Docker
docker-compose up -d

# 2. Install Laravel dependencies locally
composer install

# 3. Configure environment
cp .env.example .env
php artisan key:generate

# 4. Run migrations
php artisan migrate
php artisan db:seed --class=TemplateSeeder

# 5. Start Laravel server LOCALLY
php artisan serve --port=8080
```

## Common Mistake

❌ **Don't try to build an app Docker image!**
- There is NO app container
- The `Dockerfile.old` is archived and should NOT be used
- Students run Laravel directly on their computers

## For Complete Instructions

See **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** for full step-by-step setup.

## Verify Your Setup

Run the test script:
```bash
./test-setup.sh
```

This checks if everything is configured correctly.
