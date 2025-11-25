# Email Signature Generator - Complete Setup Guide

## 🎯 Quick Navigation
- [Prerequisites](#prerequisites)
- [Quick Start (Docker)](#quick-start-docker)
- [Manual Setup](#manual-setup)
- [Environment Configuration](#environment-configuration)
- [Database Setup](#database-setup)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

#### Option 1: Docker Setup (Recommended)
- **Docker Desktop 4.0+** ([Download](https://www.docker.com/products/docker-desktop))
- **Node.js 16+** for frontend ([Download](https://nodejs.org/))
- **Git** ([Download](https://git-scm.com/downloads))

#### Option 2: Manual Setup
- **Python 3.11+** ([Download](https://www.python.org/downloads/))
- **MySQL 8.0+** ([Download](https://dev.mysql.com/downloads/mysql/))
- **Node.js 16+** ([Download](https://nodejs.org/))
- **Git** ([Download](https://git-scm.com/downloads))

### System Requirements
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 2GB minimum
- **OS**: macOS, Linux, or Windows 10/11

---

## Quick Start (Docker)

### Step 1: Clone Repository

```bash
git clone https://github.com/AndorH1/email_generator.git
cd email_generator
```

### Step 2: Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Generate secure SECRET_KEY (copy the output)
python3 -c "import secrets; print(secrets.token_urlsafe(32))"

# Edit .env file with your values
nano .env
```

**Update these values in `.env`:**
```env
SECRET_KEY=<paste-generated-key-here>
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_PASSWORD=your_secure_app_password
```

### Step 3: Start Backend with Docker

```bash
# Start MySQL and Backend
docker-compose up -d

# Wait for services to start (check logs)
docker-compose logs -f
```

**Wait until you see:**
```
email_signature_backend | Application startup complete.
```

Press `Ctrl+C` to exit logs.

### Step 4: Initialize Database

```bash
# Load database schema
docker exec -i email_signature_db mysql -uroot -p$(grep MYSQL_ROOT_PASSWORD .env | cut -d '=' -f2) email_signature_db < database/schema.sql

# Load sample data (optional but recommended)
docker exec -i email_signature_db mysql -uroot -p$(grep MYSQL_ROOT_PASSWORD .env | cut -d '=' -f2) email_signature_db < database/seed_data.sql
```

### Step 5: Start Frontend

```bash
# Start frontend server
npx http-server ./frontend -p 3000 -c-1
```

### Step 6: Access Application

Open your browser:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs

**Test Login Credentials:**
- Email: `john.doe@example.com`
- Password: `password123`

---

## Manual Setup

### Backend Setup

#### 1. Create Virtual Environment

```bash
cd backend

# Create virtual environment
python3 -m venv venv

# Activate (macOS/Linux)
source venv/bin/activate

# Activate (Windows)
venv\Scripts\activate
```

#### 2. Install Python Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

#### 3. Configure Environment

```bash
cp .env.example .env
nano .env
```

Update `.env`:
```env
DATABASE_URL=mysql+pymysql://appuser:apppassword@localhost:3306/email_signature_db
SECRET_KEY=<generate-with-command-below>
```

Generate SECRET_KEY:
```bash
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

#### 4. Start Backend Server

```bash
# Development mode (with auto-reload)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend Setup

#### 1. Configure API Endpoint

Edit `frontend/js/config.js` if needed:
```javascript
const API_BASE_URL = 'http://localhost:8000/api';
```

#### 2. Start Frontend Server

```bash
# Using npx (no installation needed)
npx http-server ./frontend -p 3000 -c-1
```

### Database Setup (Manual)

#### 1. Install MySQL

Download and install MySQL 8.0 from [official site](https://dev.mysql.com/downloads/mysql/).

#### 2. Create Database

```bash
# Connect to MySQL
mysql -u root -p

# Create database
CREATE DATABASE email_signature_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Create user
CREATE USER 'appuser'@'localhost' IDENTIFIED BY 'apppassword';
GRANT ALL PRIVILEGES ON email_signature_db.* TO 'appuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### 3. Initialize Schema

```bash
mysql -u appuser -p email_signature_db < database/schema.sql
```

#### 4. Load Sample Data (Optional)

```bash
mysql -u appuser -p email_signature_db < database/seed_data.sql
```

---

## Environment Configuration

### Root `.env` File

```env
# Database Configuration
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_DATABASE=email_signature_db
MYSQL_USER=appuser
MYSQL_PASSWORD=your_secure_app_password

# Backend Configuration
DATABASE_URL=mysql+pymysql://appuser:your_secure_app_password@mysql:3306/email_signature_db
SECRET_KEY=your-very-secure-secret-key-min-32-characters-long

# JWT Configuration
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=10080  # 7 days

# Environment
ENVIRONMENT=development
```

### Backend `.env` File (if running manually)

Create `backend/.env`:
```env
DATABASE_URL=mysql+pymysql://appuser:apppassword@localhost:3306/email_signature_db
SECRET_KEY=your-very-secure-secret-key-min-32-characters-long
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=10080
ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
ENVIRONMENT=development
```

---

## Database Setup Details

### Schema Overview

The application uses 4 main tables:

1. **users** - User accounts (email, password, role)
2. **profiles** - User profile information (job title, phone, website)
3. **templates** - Email signature templates
4. **signatures** - User-created signatures

### Sample Data

After loading `seed_data.sql`, you'll have:

**6 Test Users:**
- john.doe@example.com (password: password123) - Student
- jane.smith@example.com (password: password123) - Student
- bob.wilson@example.com (password: password123) - Student
- alice.brown@example.com (password: password123) - Student
- charlie.davis@example.com (password: password123) - Student
- admin@example.com (password: admin123) - Admin

**6 Professional Templates:**
- Classic Professional
- Modern Card
- Corporate Blue
- Elegant Simple
- Minimalist
- Rounded Style

**5 Sample Signatures** for testing

---

## Docker Commands Reference

### Starting Services

```bash
# Start all services
docker-compose up -d

# Start and watch logs
docker-compose up

# Start specific service
docker-compose up -d mysql
```

### Stopping Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (deletes database)
docker-compose down -v
```

### Viewing Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f mysql
```

### Restarting Services

```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart backend
```

### Rebuilding Images

```bash
# Rebuild and restart
docker-compose up -d --build

# Force rebuild
docker-compose build --no-cache
```

### Database Commands

```bash
# Connect to MySQL
docker exec -it email_signature_db mysql -uroot -p

# Run SQL file
docker exec -i email_signature_db mysql -uroot -ppassword email_signature_db < file.sql

# Backup database
docker exec email_signature_db mysqldump -uroot -ppassword email_signature_db > backup.sql

# Restore database
docker exec -i email_signature_db mysql -uroot -ppassword email_signature_db < backup.sql
```

---

## Troubleshooting

### Issue: Port Already in Use

**Error:** `Address already in use`

**Solution:**
```bash
# Find process using port
lsof -i :8000  # Backend
lsof -i :3306  # MySQL
lsof -i :3000  # Frontend

# Kill process
kill -9 <PID>

# Or use different port
uvicorn app.main:app --reload --port 8001
```

### Issue: Database Connection Failed

**Error:** `Can't connect to MySQL server`

**Solution:**
```bash
# Check MySQL is running
docker ps | grep mysql

# Restart MySQL
docker-compose restart mysql

# Check logs
docker-compose logs mysql

# Wait for healthy status
docker-compose ps
```

### Issue: Docker Build Fails

**Error:** `failed to solve with frontend dockerfile.v0`

**Solution:**
```bash
# Update Docker (requires 20.10+)
docker --version

# Clean Docker cache
docker system prune -a

# Rebuild without cache
docker-compose build --no-cache
```

### Issue: CORS Errors

**Error:** `Access to fetch blocked by CORS policy`

**Solution:**

Edit `backend/app/main.py`:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://127.0.0.1:3000"  # Add your frontend URL
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Issue: Module Not Found Error

**Error:** `ModuleNotFoundError: No module named 'fastapi'`

**Solution:**
```bash
# Activate virtual environment first
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt
```

### Issue: JWT Token Expired

**Error:** `Could not validate credentials`

**Solution:**
```bash
# Clear localStorage in browser console (F12)
localStorage.clear()

# Or increase token lifetime in .env
ACCESS_TOKEN_EXPIRE_MINUTES=10080  # 7 days
```

### Issue: Frontend Shows Blank Page

**Solution:**
```bash
# Check browser console (F12) for errors

# Restart frontend with no cache
npx http-server ./frontend -p 3000 -c-1

# Hard refresh browser
# macOS: Cmd+Shift+R
# Windows/Linux: Ctrl+Shift+R
```

### Issue: Images Not Displaying

**Problem:** Email signature images show broken links

**Solution:**
- Use direct image URLs ending in .jpg, .png, etc.
- Avoid Google Photos/Drive links
- Use free hosting services:
  - Imgur: https://imgur.com
  - PostImages: https://postimages.org
  - ImgBB: https://imgbb.com

---

## Verification Steps

After setup, verify everything works:

### 1. Backend Health Check

```bash
curl http://localhost:8000/health
# Expected: {"status":"healthy"}
```

### 2. API Documentation

Open in browser: http://localhost:8000/docs

### 3. Test Registration

```bash
curl -X POST http://localhost:8000/api/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123","full_name":"Test User"}'
```

### 4. Test Login

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

### 5. Frontend Access

Open browser: http://localhost:3000

Try logging in with:
- Email: `john.doe@example.com`
- Password: `password123`

---

## Next Steps

1. ✅ **Create Your First Signature**
   - Login → Dashboard → "Create New Signature"
   - Select a template
   - Fill in your details
   - Click "Update Preview" → "Save Signature"

2. ✅ **Manage Signatures**
   - Edit: Click "Edit" button
   - Copy: Click "Copy HTML" button
   - Delete: Click "Delete" button

3. ✅ **Update Profile**
   - Click "Profile" in navigation
   - Update your information
   - Save changes

4. ✅ **Export Signature**
   - From Dashboard, click "Copy HTML"
   - Paste into your email client settings

---

## Production Deployment

For production deployment, see:
- [Production Deployment Guide](PRODUCTION.md)
- [Migration Guide](MIGRATION.md)

---

## Support

- **Documentation**: See `docs/` folder
- **Issues**: Open issue on GitHub
- **API Reference**: http://localhost:8000/docs

---

**Last Updated:** November 25, 2025  
**Version:** 1.0.0
