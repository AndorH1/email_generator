# WSL Compatibility Test

Run this in your WSL terminal to verify everything works:

```bash
# 1. Check WSL version (should be 2)
wsl --version

# 2. Check Docker is accessible from WSL
docker --version

# 3. Check Docker is running
docker ps

# 4. Pull MySQL image (multi-platform)
docker pull mysql:8.0

# 5. Verify image supports linux/amd64 (WSL platform)
docker image inspect mysql:8.0 --format='{{.Architecture}}'
# Should output: amd64

# 6. Start MySQL
docker-compose up -d

# 7. Verify MySQL is accessible from WSL
docker exec -it email_signature_db mysql -uroot -ppassword -e "SELECT VERSION();"

# 8. Check PHP is installed in WSL
php -v

# 9. Check Composer is installed in WSL
composer --version

# 10. Test localhost port forwarding (WSL → Windows)
# Start Laravel: php artisan serve --port=8080
# Open Windows browser: http://localhost:8080
# WSL automatically forwards ports to Windows!
```

## Expected Results:

✅ All commands should run without errors in WSL Ubuntu terminal
✅ Windows browser can access http://localhost:8080
✅ MySQL container runs on linux/amd64 architecture
✅ Laravel connects to MySQL via 127.0.0.1:3306

## Why This Works:

1. **WSL 2** uses actual Linux kernel - runs Docker natively
2. **Docker Desktop** integrates with WSL - containers run in WSL
3. **MySQL image** supports linux/amd64 - perfect for WSL
4. **Port forwarding** - WSL automatically forwards ports to Windows
5. **Filesystem** - Can access Windows files from `/mnt/c/` if needed

## Common WSL Issues:

### Issue: Docker commands not found in WSL
**Solution:**
1. Open Docker Desktop on Windows
2. Settings → Resources → WSL Integration
3. Enable "Ubuntu" (or your distro)
4. Click "Apply & Restart"
5. Restart WSL: `wsl --shutdown` then reopen Ubuntu

### Issue: Can't access localhost from Windows browser
**Solution:**
```bash
# In WSL, find your IP
ip addr show eth0 | grep inet

# Use that IP in Windows browser
# Example: http://172.24.123.45:8080
```

### Issue: MySQL port already in use
**Solution:**
```bash
# Check what's using port 3306 in WSL
sudo lsof -i :3306

# Or use different port
docker run -d --name email_signature_db -p 3307:3306 -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=email_signature_db mysql:8.0

# Update .env: DB_PORT=3307
```

## Performance Tips:

✅ **DO:** Store project files in WSL filesystem (`~/Projects/`)
❌ **DON'T:** Store files in Windows filesystem (`/mnt/c/`)

**Why?** 
- WSL filesystem = Fast ⚡
- Windows filesystem via WSL = Slow 🐌

```bash
# Good: Fast
cd ~/Projects/email_generator

# Bad: Slow
cd /mnt/c/Users/YourName/Projects/email_generator
```
