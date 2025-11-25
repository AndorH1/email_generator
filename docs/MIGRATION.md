# Migration Guide

This guide helps you migrate the Email Signature Generator to a new environment.

## Prerequisites

- Docker and Docker Compose installed
- Git installed
- Access to Docker Hub (if pulling pre-built image)

## Migration Steps

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/email-signature-generator.git
cd email-signature-generator
```

### 2. Configure Environment Variables

```bash
# Copy environment template
cp .env.example .env

# Edit with your values
nano .env
```

**Important variables to change:**

```env
# Generate a new SECRET_KEY
SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")

# Update database passwords
MYSQL_ROOT_PASSWORD=your_new_root_password
MYSQL_PASSWORD=your_new_app_password

# Update DATABASE_URL to match
DATABASE_URL=mysql+pymysql://appuser:your_new_app_password@mysql:3306/email_signature_db
```

### 3. Option A: Use Docker Hub Image (Recommended)

```bash
# Pull latest image
docker pull could198/email-signature-generator:latest

# Start services
docker-compose up -d
```

### 3. Option B: Build Locally

```bash
# Build image
docker-compose build

# Start services
docker-compose up -d
```

### 4. Initialize Database

```bash
# Wait for MySQL to be ready (check logs)
docker-compose logs -f mysql

# Load schema
docker exec -i email_signature_db mysql -uroot -p$(grep MYSQL_ROOT_PASSWORD .env | cut -d '=' -f2) email_signature_db < database/schema.sql

# Load sample data (optional)
docker exec -i email_signature_db mysql -uroot -p$(grep MYSQL_ROOT_PASSWORD .env | cut -d '=' -f2) email_signature_db < database/seed_data.sql
```

### 5. Start Frontend

```bash
# Install http-server if needed
npm install -g http-server

# Start frontend
npx http-server ./frontend -p 3000 -c-1
```

### 6. Verify Installation

```bash
# Check backend health
curl http://localhost:8000/health

# Check API docs
open http://localhost:8000/docs

# Access frontend
open http://localhost:3000
```

## Migrating Existing Data

### Export Data from Old Environment

```bash
# Export database
docker exec email_signature_db mysqldump -uroot -ppassword email_signature_db > backup.sql

# Or from local MySQL
mysqldump -u appuser -p email_signature_db > backup.sql
```

### Import Data to New Environment

```bash
# Using Docker
docker exec -i email_signature_db mysql -uroot -pNEW_PASSWORD email_signature_db < backup.sql

# Or local MySQL
mysql -u appuser -p email_signature_db < backup.sql
```

## Environment-Specific Configuration

### Development

```env
ENVIRONMENT=development
ACCESS_TOKEN_EXPIRE_MINUTES=10080  # 7 days
```

### Production

```env
ENVIRONMENT=production
ACCESS_TOKEN_EXPIRE_MINUTES=1440  # 24 hours
SECRET_KEY=<very-long-random-string>
```

### Update CORS Origins

In `backend/app/main.py`, update allowed origins:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://yourdomain.com",  # Production domain
        "http://localhost:3000"    # Development
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## Rollback Procedure

If migration fails:

```bash
# Stop new services
docker-compose down

# Restore old database backup
docker-compose up -d mysql
docker exec -i email_signature_db mysql -uroot -ppassword email_signature_db < old_backup.sql

# Restart old backend
docker-compose up -d backend
```

## Post-Migration Checklist

- [ ] Backend health check returns 200
- [ ] Can login with test credentials
- [ ] Can create new signature
- [ ] Can export signature HTML
- [ ] Database has correct data
- [ ] All API endpoints work (test with `/docs`)
- [ ] Frontend loads correctly
- [ ] No CORS errors in browser console
- [ ] Images display in signatures

## Troubleshooting

### Database Connection Issues

```bash
# Check MySQL container
docker ps | grep mysql

# View MySQL logs
docker-compose logs mysql

# Test connection
docker exec -it email_signature_db mysql -uroot -p
```

### Backend Not Starting

```bash
# Check backend logs
docker-compose logs backend

# Verify environment variables
docker exec email_signature_backend env | grep DATABASE_URL

# Restart backend
docker-compose restart backend
```

### Port Conflicts

```bash
# Check what's using ports
lsof -i :3306  # MySQL
lsof -i :8000  # Backend
lsof -i :3000  # Frontend

# Stop conflicting process or use different ports
# Edit docker-compose.yml to change ports
```

## Support

For issues during migration:
1. Check [README.md](README.md) troubleshooting section
2. Review Docker logs: `docker-compose logs`
3. Verify environment variables in `.env`
4. Open GitHub issue with error details
