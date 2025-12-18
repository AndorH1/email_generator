# Setup Checklist for Windows WSL Students

Copy this checklist and mark off each step as you complete it.

## Pre-Setup Checklist

- [ ] Windows 10/11 installed
- [ ] WSL 2 installed (`wsl --install` in PowerShell as Admin)
- [ ] Ubuntu installed from Microsoft Store (or comes with WSL)
- [ ] Docker Desktop installed on Windows
- [ ] Docker Desktop → Settings → WSL Integration → Ubuntu is enabled

## Files Needed

- [ ] `docker-compose.yml` - copied to WSL
- [ ] `MIGRATION_GUIDE.md` - copied to WSL (for reference)

## WSL Setup Steps

- [ ] Open WSL terminal (type `wsl` in PowerShell or open Ubuntu from Start Menu)
- [ ] Create project directory: `mkdir -p ~/Projects/email-signature-generator`
- [ ] Navigate to directory: `cd ~/Projects/email-signature-generator`
- [ ] Copy `docker-compose.yml` to this directory
- [ ] Verify Docker works: `docker --version`

## Docker MySQL Setup

- [ ] Start MySQL container: `docker-compose up -d`
- [ ] Check container is running: `docker ps` (should see `email_signature_db`)
- [ ] Wait 10 seconds for MySQL to be ready
- [ ] Test connection: `docker exec -it email_signature_db mysql -uroot -ppassword email_signature_db`
- [ ] Type `SHOW DATABASES;` in MySQL shell (should see `email_signature_db`)
- [ ] Exit MySQL: `EXIT;`

## Install Prerequisites in WSL

- [ ] Update packages: `sudo apt update`
- [ ] Install PHP: `sudo apt install -y php8.2 php8.2-cli php8.2-mbstring php8.2-xml php8.2-curl php8.2-mysql php8.2-zip`
- [ ] Verify PHP: `php -v` (should show PHP 8.2+)
- [ ] Install Composer: `curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer`
- [ ] Verify Composer: `composer --version`

## Laravel Project Setup

- [ ] Clone repository OR copy Laravel files to `~/Projects/email-signature-generator`
- [ ] Install dependencies: `composer install`
- [ ] Copy environment file: `cp .env.example .env`
- [ ] Generate app key: `php artisan key:generate`
- [ ] Verify `.env` has correct database settings:
  ```
  DB_CONNECTION=mysql
  DB_HOST=127.0.0.1
  DB_PORT=3306
  DB_DATABASE=email_signature_db
  DB_USERNAME=root
  DB_PASSWORD=password
  ```
- [ ] Run migrations: `php artisan migrate`
- [ ] Seed templates: `php artisan db:seed --class=TemplateSeeder`

## Start Laravel

- [ ] Start server: `php artisan serve --port=8080`
- [ ] Open Windows browser: `http://localhost:8080`
- [ ] Register a new account
- [ ] Login and create a signature

## Verification

- [ ] Can access homepage
- [ ] Can register new user
- [ ] Can login
- [ ] Can create profile
- [ ] Can create signature from template
- [ ] Can export signature as HTML

## Troubleshooting Checklist

If something doesn't work:

- [ ] Docker Desktop is running on Windows (check system tray)
- [ ] MySQL container is running: `docker ps`
- [ ] Can connect to MySQL: `docker exec -it email_signature_db mysql -uroot -ppassword email_signature_db`
- [ ] `.env` file has correct database credentials
- [ ] Migrations ran successfully: `php artisan migrate:status`
- [ ] Laravel server is running: check terminal for "Server running on..."
- [ ] Check Laravel logs: `tail -f storage/logs/laravel.log`

## Common Commands Reference

```bash
# Start MySQL
docker-compose up -d

# Stop MySQL
docker-compose down

# Restart MySQL
docker-compose restart

# View MySQL logs
docker logs email_signature_db

# Connect to MySQL
docker exec -it email_signature_db mysql -uroot -ppassword email_signature_db

# Start Laravel
php artisan serve --port=8080

# Check Laravel routes
php artisan route:list

# Clear Laravel cache
php artisan optimize:clear
```

## Daily Workflow

When you start working:
1. [ ] Open Docker Desktop (wait for it to start)
2. [ ] Open WSL terminal
3. [ ] `cd ~/Projects/email-signature-generator`
4. [ ] `docker-compose up -d` (if not running)
5. [ ] `php artisan serve --port=8080`
6. [ ] Open browser to http://localhost:8080

When you finish:
1. [ ] Stop Laravel (Ctrl+C in terminal)
2. [ ] `docker-compose down` (optional - can leave running)

---

✅ **Setup Complete!** You should now have a working Laravel application with MySQL running in Docker.
