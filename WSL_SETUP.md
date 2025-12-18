# For Windows WSL Students - Quick Setup

## What You Need to Copy

Copy these files to your WSL home directory:
- `docker-compose.yml` (REQUIRED - runs MySQL)
- `MIGRATION_GUIDE.md` (REQUIRED - setup instructions)

❌ **DO NOT copy `Dockerfile.old`** - it's not used!

## Steps in WSL Terminal

```bash
# 1. Open WSL terminal (Ubuntu)
# Press Win + R, type "wsl", press Enter

# 2. Create project directory
cd ~
mkdir Projects
cd Projects
mkdir email-signature-generator
cd email-signature-generator

# 3. Copy the docker-compose.yml file here
# Either:
#   - Use VS Code: code docker-compose.yml
#   - Or copy from Windows: cp /mnt/c/path/to/docker-compose.yml .

# 4. Start MySQL container
docker-compose up -d

# 5. Verify MySQL is running
docker ps
# Should show: email_signature_db

# 6. Test MySQL connection
docker exec -it email_signature_db mysql -uroot -ppassword email_signature_db

# 7. Now clone the Laravel project or copy the Laravel files
# Continue with MIGRATION_GUIDE.md from Step 4
```

## Verify Docker Desktop WSL Integration

Before running docker-compose:

1. Open **Docker Desktop** on Windows
2. Go to **Settings** → **Resources** → **WSL Integration**
3. Make sure **"Enable integration with my default WSL distro"** is ON
4. Make sure **Ubuntu** toggle is ON
5. Click **"Apply & Restart"**

## Common Issues

**"docker: command not found" in WSL**
- Make sure Docker Desktop is running on Windows
- Check WSL integration in Docker Desktop settings

**"Cannot connect to the Docker daemon"**
- Restart Docker Desktop
- Wait 10-15 seconds for it to fully start
- Try again

**Permission errors**
- Run: `sudo usermod -aG docker $USER`
- Logout and login to WSL again

## What Happens When You Run docker-compose up

✅ Downloads MySQL 8.0 image (if not already downloaded)
✅ Creates `email_signature_db` container
✅ Creates `email_signature_db` database inside container
✅ Container runs in background on port 3306

❌ Does NOT build any app image
❌ Does NOT use Dockerfile
❌ Does NOT run Laravel (you run that locally with `php artisan serve`)

## Accessing MySQL

```bash
# Connect to MySQL shell
docker exec -it email_signature_db mysql -uroot -ppassword email_signature_db

# Inside MySQL shell, run queries:
mysql> SHOW TABLES;
mysql> SELECT * FROM users;
mysql> EXIT;
```

## Stopping MySQL

```bash
# Stop but keep data
docker-compose down

# Stop and delete all data (be careful!)
docker-compose down -v
```

## Next Steps

Once MySQL is running in Docker, follow **MIGRATION_GUIDE.md** to:
1. Install PHP, Composer in WSL
2. Clone/copy the Laravel project
3. Run `composer install`
4. Configure `.env`
5. Run migrations
6. Start Laravel with `php artisan serve --port=8080`
