# Email Signature Generator - Migration Guide

**Complete step-by-step guide for students to set up and run this project.**

> **Architecture:** MySQL runs in Docker, Laravel application runs locally on your machine.
>
> ✅ **Fully compatible with WSL on Windows** - All commands work in WSL terminal (Ubuntu)

---

## ⚠️ IMPORTANT: Read This First!

**What runs where:**
- ✅ **MySQL Database** → Runs in Docker container (using official `mysql:8.0` image)
- ✅ **Laravel Application** → Runs LOCALLY with `php artisan serve` on your machine
- ❌ **NO Dockerfile needed** → We don't build any Docker images for the app

**Common Mistakes:**
- ❌ Don't try to build a Docker image (`docker build .`)
- ❌ Don't try to run Laravel in Docker
- ❌ Don't use `docker-compose build`
- ✅ Just run `docker-compose up -d` to start MySQL only
- ✅ Then run `php artisan serve` to start Laravel locally

---

## 📋 Quick Overview

1. Install prerequisites (PHP, Composer, Docker)
2. Clone the repository
3. Start MySQL in Docker (NO build needed - just pulls MySQL image)
4. Install Laravel dependencies
5. Configure environment
6. Run migrations and seeders
7. Start Laravel server locally
8. Access the application

---

## Step 1: Install Prerequisites

### Windows Users - WSL Setup

**This is required for Windows users!**

```powershell
# Open PowerShell as Administrator
wsl --install

# Restart your computer

# After restart, set WSL 2 as default
wsl --set-default-version 2

# Open Ubuntu from Start Menu and create username/password
```

### Install Docker Desktop

**Windows:**
- Download: https://www.docker.com/products/docker-desktop/
- Install and restart
- Enable WSL Integration: Settings → Resources → WSL Integration → Enable Ubuntu

**macOS:**
```bash
# Download from Docker website or use Homebrew
brew install --cask docker
```

**Linux:**
```bash
sudo apt update
sudo apt install docker.io docker-compose
sudo systemctl start docker
sudo usermod -aG docker $USER
# Logout and login again
```

Verify Docker installation:
```bash
docker --version
docker-compose --version
```

### Install PHP 8.2+

**Windows (in WSL terminal):**
```bash
sudo apt update
sudo apt install -y php8.2 php8.2-cli php8.2-mbstring php8.2-xml \
  php8.2-curl php8.2-mysql php8.2-zip php8.2-gd php8.2-bcmath
php -v
```

**macOS:**
```bash
brew install php@8.2
brew link php@8.2
php -v
```

**Linux:**
```bash
sudo apt update
sudo apt install -y php8.2 php8.2-cli php8.2-mbstring php8.2-xml \
  php8.2-curl php8.2-mysql php8.2-zip php8.2-gd php8.2-bcmath
php -v
```

### Install Composer

```bash
# Download and install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Verify installation
composer --version
```

---

## Step 2: Clone the Repository

```bash
# For Windows: Use WSL terminal and work in WSL filesystem
cd ~
mkdir -p Projects
cd Projects

# Clone the repository
git clone https://github.com/AndorH1/email_generator.git
cd email_generator

# Switch to the correct branch
git checkout transgform-php-laravel
```

---

## Step 3: Start MySQL in Docker

> **Important:** We only run MySQL in Docker, NOT the Laravel application. Laravel runs locally with `php artisan serve`.

> **Note:** The official MySQL 8.0 image supports both AMD64 (WSL/Intel) and ARM64 (Mac M1/M2) architectures automatically.

### Option A: Using docker-compose (Recommended)

```bash
# In WSL terminal (Windows) or regular terminal (macOS/Linux)
# Start MySQL container ONLY (no app container)
docker-compose up -d

# Check if container is running
docker ps

# You should see: email_signature_db container running on port 3306
# You should NOT see any "app" or "backend" container - that's correct!
```

**What if I see build errors?**
- If you see Dockerfile build errors, ignore them - we don't build any app image
- The docker-compose.yml only pulls the official MySQL image
- If errors persist, make sure you're using the correct docker-compose.yml (MySQL only)

### Option B: Using Docker Run command

```bash
docker run -d \
  --name email_signature_db \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=email_signature_db \
  -p 3306:3306 \
  mysql:8.0
```

### Verify MySQL is Running

```bash
# Check container status
docker ps

# Check MySQL logs (optional)
docker logs email_signature_db

# Wait for MySQL to be ready (you should see "ready for connections")
```

---

## Step 4: Install Laravel Dependencies

```bash
# Make sure you're in the project directory
cd ~/Projects/email_generator  # or your project path

# Install PHP dependencies
composer install

# This will take 1-2 minutes
```

---

## Step 5: Configure Environment

```bash
# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate
```

**Edit `.env` file** (use nano, vim, or VS Code):

```bash
nano .env
```

Update these database settings:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=email_signature_db
DB_USERNAME=root
DB_PASSWORD=password

# Session and cache (use file driver)
SESSION_DRIVER=file
CACHE_STORE=file

# Application URL
APP_URL=http://localhost:8080
```

Save and exit (Ctrl+X, then Y, then Enter).

---

## Step 6: Run Migrations and Seeders

```bash
# Run database migrations (creates tables)
php artisan migrate

# Seed template data (creates 3 default templates)
php artisan db:seed --class=TemplateSeeder

# Verify migrations were successful
php artisan migrate:status
```

You should see output showing all migrations ran successfully:
```
Migration name ................... Batch / Status
0001_01_01_000000_create_users_table ........ [1] Ran
0001_01_01_000001_create_cache_table ........ [1] Ran
0001_01_01_000002_create_jobs_table ......... [1] Ran
2024_11_01_000001_create_personal_access_tokens_table ... [1] Ran
2024_11_01_000002_create_profiles_table ..... [1] Ran
2024_11_01_000003_create_templates_table .... [1] Ran
2024_11_01_000004_create_signatures_table ... [1] Ran
```

---

## Step 7: Start Laravel Development Server

```bash
# Start the server on port 8080
php artisan serve --port=8080

# You should see:
# INFO  Server running on [http://127.0.0.1:8080]
```

**Keep this terminal open!** The server runs in the foreground.

---

## Step 8: Access the Application

Open your browser and navigate to:
```
http://localhost:8080
```

You should see the Email Signature Generator homepage!

### Test the Application:

1. **Register a new account:**
   - Click "Register"
   - Fill in: email, password, full name
   - Submit

2. **Login:**
   - Use your registered credentials

3. **Create a signature:**
   - Go to Dashboard
   - Click "Create New Signature"
   - Choose a template
   - Fill in your details
   - Save

---

## Working with MySQL in Terminal

### Connect to MySQL Container

```bash
# Connect to MySQL
docker exec -it email_signature_db mysql -uroot -ppassword email_signature_db

# You're now in MySQL shell
# You should see: mysql>
```

### Useful SQL Commands

```sql
-- Show all tables
SHOW TABLES;

-- View all users
SELECT * FROM users;

-- View all templates
SELECT * FROM templates;

-- View all signatures
SELECT * FROM signatures;

-- View user profiles
SELECT * FROM profiles;

-- Count signatures per user
SELECT user_id, COUNT(*) as signature_count 
FROM signatures 
GROUP BY user_id;

-- View signature with template name
SELECT s.id, s.name, t.name as template_name, s.created_at
FROM signatures s
JOIN templates t ON s.template_id = t.id;

-- Exit MySQL shell
EXIT;
```

### Export Database

```bash
# Export entire database
docker exec email_signature_db mysqldump -uroot -ppassword email_signature_db > backup.sql

# Export specific table
docker exec email_signature_db mysqldump -uroot -ppassword email_signature_db signatures > signatures_backup.sql
```

### Import Database

```bash
# Import database
docker exec -i email_signature_db mysql -uroot -ppassword email_signature_db < backup.sql
```

---

## Daily Workflow

### Starting Your Work Session

```bash
# 1. Make sure Docker is running
docker ps

# 2. If MySQL container is not running, start it
docker start email_signature_db
# Or use docker-compose
docker-compose up -d

# 3. Navigate to project
cd ~/Projects/email_generator

# 4. Start Laravel server
php artisan serve --port=8080

# 5. Open browser to http://localhost:8080
```

### Stopping Your Work Session

```bash
# 1. Stop Laravel server (Ctrl+C in the terminal)

# 2. Stop MySQL container (optional - can leave running)
docker stop email_signature_db
# Or
docker-compose down

# Note: Stopping the container preserves your data
```

---

## Troubleshooting

### Issue: "Error building Docker image" or "Dockerfile not found" or "Step 6/6 RUN chown failed"

**Problem:** You're trying to build a Docker image, but this project doesn't need one!

**Solution:** 
This project runs **MySQL in Docker** and **Laravel locally**. There is NO Dockerfile and you should NOT try to build one.

```bash
# WRONG - Don't do this:
docker build .
docker-compose build

# CORRECT - Just start MySQL:
docker-compose up -d

# Then run Laravel locally:
php artisan serve --port=8080
```

**What you should see:**
- `docker-compose up -d` downloads the official MySQL image (once)
- `docker ps` shows only ONE container: `email_signature_db`
- No "build" steps, no Dockerfile errors

**If you see multiple containers or build errors:**
1. Stop everything: `docker-compose down`
2. Check `docker-compose.yml` - it should only have a `mysql` service
3. Make sure there's no `Dockerfile` in your project root
4. Run again: `docker-compose up -d`

---

### Issue: "Connection refused" when running migrations

**Solution:** Make sure MySQL container is running and healthy:

```bash
# Check container status
docker ps

# Check MySQL logs
docker logs email_signature_db

# Wait for "ready for connections" message
docker logs -f email_signature_db
```

### Issue: Port 3306 already in use

**Solution:** Another MySQL is running locally:

```bash
# Windows (WSL) / Linux
sudo service mysql stop

# macOS
brew services stop mysql

# Or change Docker port
docker run -d \
  --name email_signature_db \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=email_signature_db \
  -p 3307:3306 \
  mysql:8.0

# Then update .env: DB_PORT=3307
```

### Issue: Port 8080 already in use

**Solution:** Use a different port:

```bash
php artisan serve --port=8000

# Update APP_URL in .env: APP_URL=http://localhost:8000
```

### Issue: "Class 'PDO' not found"

**Solution:** Install PHP MySQL extension:

```bash
# Windows (WSL) / Linux
sudo apt install php8.2-mysql

# macOS
brew install php@8.2
```

### Issue: Cannot access from Windows browser (WSL users)

**Solution:** WSL forwards ports automatically, use `localhost`:

```
http://localhost:8080
```

If that doesn't work, find your WSL IP:

```bash
# In WSL terminal
ip addr show eth0 | grep inet

# Use that IP in browser: http://172.x.x.x:8080
```

### Issue: Permission denied on storage folder

**Solution:** Fix Laravel permissions:

```bash
chmod -R 775 storage bootstrap/cache
```

---

## Docker Commands Reference

### Container Management

```bash
# Start MySQL container
docker start email_signature_db

# Stop MySQL container
docker stop email_signature_db

# Restart MySQL container
docker restart email_signature_db

# Remove container (data is preserved in volume)
docker rm email_signature_db

# View container logs
docker logs email_signature_db

# Follow logs in real-time
docker logs -f email_signature_db

# View container details
docker inspect email_signature_db
```

### Using Docker Compose

```bash
# Start MySQL
docker-compose up -d

# Stop MySQL
docker-compose down

# View logs
docker-compose logs -f

# Restart MySQL
docker-compose restart

# Remove everything including volumes (DELETES ALL DATA!)
docker-compose down -v
```

### Volume Management

```bash
# List volumes
docker volume ls

# Inspect mysql_data volume
docker volume inspect mysql_data

# Remove volume (DELETES ALL DATA!)
docker volume rm mysql_data
```

---

## Testing the API Directly

You can test API endpoints using curl:

```bash
# Register
curl -X POST http://localhost:8080/api/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","full_name":"Test User"}'

# Login (save the token from response)
curl -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get templates (no auth required)
curl http://localhost:8080/api/templates

# Get profile (replace YOUR_TOKEN)
curl http://localhost:8080/api/profile \
  -H "Authorization: Bearer YOUR_TOKEN"

# Get signatures
curl http://localhost:8080/api/signatures \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## Project Structure

```
email_generator/
├── app/
│   ├── Http/
│   │   └── Controllers/
│   │       └── Api/          # API Controllers
│   ├── Models/               # Eloquent Models
│   └── schemas/              # Request validation
├── database/
│   ├── migrations/           # Database migrations
│   └── seeders/              # Data seeders
├── public/                   # Frontend files
│   ├── js/
│   ├── css/
│   └── *.html
├── routes/
│   ├── api.php              # API routes
│   └── web.php              # Web routes
├── .env                     # Environment configuration
├── docker-compose.yml       # MySQL Docker setup
└── artisan                  # Laravel CLI
```

---

## Common Laravel Artisan Commands

```bash
# View all available commands
php artisan list

# Clear all caches
php artisan optimize:clear

# Run migrations
php artisan migrate

# Rollback last migration
php artisan migrate:rollback

# Reset database (DELETES ALL DATA!)
php artisan migrate:fresh

# Run seeders
php artisan db:seed

# Create new migration
php artisan make:migration create_something_table

# Create new model
php artisan make:model ModelName

# Create new controller
php artisan make:controller ControllerName

# View routes
php artisan route:list

# Start Laravel server
php artisan serve

# Run tests
php artisan test
```

---

## Resources

- **Laravel Documentation:** https://laravel.com/docs/12.x
- **MySQL Docker Hub:** https://hub.docker.com/_/mysql
- **Docker Compose:** https://docs.docker.com/compose/
- **WSL Documentation:** https://learn.microsoft.com/en-us/windows/wsl/

---

## Need Help?

1. Check the troubleshooting section above
2. Review Laravel logs: `storage/logs/laravel.log`
3. Check MySQL logs: `docker logs email_signature_db`
4. Check PHP server output in your terminal
5. Use browser developer console (F12) for frontend errors

---

## Summary

**What runs where:**
- ✅ **MySQL** - Runs in Docker container (port 3306)
- ✅ **Laravel** - Runs locally with `php artisan serve` (port 8080)
- ✅ **Frontend** - Static files served by Laravel from `public/` directory

**Key files:**
- `.env` - Database and app configuration
- `docker-compose.yml` - MySQL container setup
- `routes/api.php` - API endpoints
- `public/` - Frontend HTML/CSS/JS

Good luck! 🚀
