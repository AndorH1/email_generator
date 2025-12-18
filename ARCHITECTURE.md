# Project Architecture

## Visual Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Your Computer                           │
│                                                             │
│  ┌────────────────────┐         ┌────────────────────┐    │
│  │   Docker Desktop   │         │   Local Terminal   │    │
│  │                    │         │                    │    │
│  │  ┌──────────────┐  │         │  ┌──────────────┐  │    │
│  │  │    MySQL     │  │◄────────┤  │   Laravel    │  │    │
│  │  │   Container  │  │ Port    │  │ php artisan  │  │    │
│  │  │              │  │ 3306    │  │    serve     │  │    │
│  │  │ email_sign.. │  │         │  │ Port 8080    │  │    │
│  │  └──────────────┘  │         │  └──────────────┘  │    │
│  │                    │         │                    │    │
│  │  Official MySQL    │         │  Runs locally      │    │
│  │  8.0 Image         │         │  (not in Docker)   │    │
│  └────────────────────┘         └────────────────────┘    │
│           ▲                              │                 │
│           │                              │                 │
│           │                              ▼                 │
│           │                     ┌────────────────────┐    │
│           └─────────────────────┤   Browser          │    │
│                                 │ localhost:8080     │    │
│                                 └────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## What Happens When You Start The Project?

### Step 1: Start MySQL in Docker
```bash
docker-compose up -d
```
**What it does:**
- Downloads official MySQL 8.0 image from Docker Hub (first time only)
- Creates a container named `email_signature_db`
- Starts MySQL server on port 3306
- Creates database `email_signature_db`
- Sets root password to `password`

**What it does NOT do:**
- ❌ Does NOT build any custom Docker image
- ❌ Does NOT run Laravel in Docker
- ❌ Does NOT need a Dockerfile

### Step 2: Start Laravel Locally
```bash
php artisan serve --port=8080
```
**What it does:**
- Starts PHP built-in web server
- Runs on your machine (not in Docker)
- Listens on port 8080
- Connects to MySQL at 127.0.0.1:3306
- Serves frontend files from `public/`

## File Structure

```
email_generator/
├── docker-compose.yml          ← Only defines MySQL service
├── .env                        ← Database config: DB_HOST=127.0.0.1
├── app/                        ← Laravel backend (runs locally)
│   ├── Http/Controllers/
│   └── Models/
├── database/
│   ├── migrations/             ← Creates tables in MySQL container
│   └── seeders/
├── public/                     ← Frontend (served by Laravel)
│   ├── index.html
│   ├── js/
│   └── css/
└── NO Dockerfile here!         ← We don't build Docker images
```

## Connection Flow

```
Browser (localhost:8080)
    │
    ▼
Laravel Server (php artisan serve)
    │
    ├─► Serves HTML/CSS/JS from public/
    │
    └─► API requests go to app/Http/Controllers/
            │
            ▼
        Eloquent Models
            │
            ▼
        MySQL in Docker (127.0.0.1:3306)
            │
            └─► Database: email_signature_db
```

## Why This Architecture?

### ✅ Benefits:
- **Simple Setup:** Students only need to run `docker-compose up -d` and `php artisan serve`
- **Fast Development:** Edit code locally, see changes immediately (no rebuilding)
- **Easy Debugging:** Laravel runs on your machine, easy to debug with var_dump, dd(), etc.
- **Database Isolation:** MySQL in Docker means consistent database across all students
- **No Port Conflicts:** Each student gets clean MySQL environment
- **WSL Compatible:** Works perfectly on Windows with WSL 2

### ❌ What We Don't Do (and why):
- **Don't run Laravel in Docker:** Adds complexity, slower file changes, harder to debug
- **Don't build custom images:** Not needed, official MySQL image works perfectly
- **Don't use Dockerfile:** Would require rebuilding every time you change code

## Commands Summary

```bash
# Start MySQL (one time per work session)
docker-compose up -d

# Connect to MySQL terminal
docker exec -it email_signature_db mysql -uroot -ppassword email_signature_db

# Run SQL queries
mysql> SHOW TABLES;
mysql> SELECT * FROM users;

# Start Laravel (in a separate terminal)
php artisan serve --port=8080

# Stop MySQL when done (optional)
docker-compose down
```

## Troubleshooting

**"I see Dockerfile errors"**
→ You shouldn't! There's no Dockerfile. Just run `docker-compose up -d`

**"Step 6/6 RUN chown failed"**
→ You're trying to build something. Don't! Just run `docker-compose up -d`

**"Container won't start"**
→ Check logs: `docker logs email_signature_db`

**"Laravel can't connect to database"**
→ Make sure `.env` has `DB_HOST=127.0.0.1` (not `mysql` or `localhost`)

**"Port 3306 already in use"**
→ Stop local MySQL: `sudo service mysql stop` (WSL/Linux) or `brew services stop mysql` (macOS)

---

For complete setup instructions, see [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)
