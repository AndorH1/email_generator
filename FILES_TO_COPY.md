# What to Copy to Windows WSL

## Essential Files (Must Copy)

### 1. docker-compose.yml ⭐ REQUIRED
```
Copy this file to: ~/Projects/email-signature-generator/docker-compose.yml
Purpose: Runs MySQL database in Docker
Size: ~1KB
```

### 2. Laravel Project Files ⭐ REQUIRED
```
Either:
  A) Clone from GitHub: git clone <repo-url>
  OR
  B) Copy entire project folder to WSL

Location: ~/Projects/email-signature-generator/
```

## Documentation Files (Helpful but Optional)

### MIGRATION_GUIDE.md
- Complete setup instructions
- Troubleshooting guide
- Copy to: ~/Projects/email-signature-generator/

### WSL_SETUP.md
- Windows WSL specific instructions
- Docker Desktop integration steps

### CHECKLIST.md
- Step-by-step checklist
- Print or keep open while setting up

## Files You DON'T Need

❌ **Dockerfile.old** - Not used, ignore it
❌ **docker-compose.mysql-only.yml** - Duplicate of docker-compose.yml
❌ **.git/** - If copying files (not if cloning)
❌ **node_modules/** - Will be created by npm install
❌ **vendor/** - Will be created by composer install

## Directory Structure After Setup

```
~/Projects/email-signature-generator/
├── docker-compose.yml          ← MySQL Docker config
├── .env                         ← Created from .env.example
├── .env.example                 ← Template
├── composer.json                ← Laravel dependencies
├── artisan                      ← Laravel CLI
├── app/                         ← Laravel app code
├── database/                    ← Migrations, seeders
├── public/                      ← Frontend files
├── routes/                      ← API and web routes
├── storage/                     ← Logs, cache, uploads
└── vendor/                      ← PHP dependencies (created by composer)
```

## Quick Copy Commands

### If files are on Windows (C:\Downloads\email-signature-generator)

```bash
# In WSL terminal
# Create directory
mkdir -p ~/Projects
cd ~/Projects

# Copy from Windows to WSL
cp -r /mnt/c/Users/YourUsername/Downloads/email-signature-generator .

# Enter directory
cd email-signature-generator

# Verify docker-compose.yml exists
ls -la docker-compose.yml
```

### If using Git

```bash
# In WSL terminal
cd ~/Projects
git clone https://github.com/AndorH1/email_generator.git email-signature-generator
cd email-signature-generator
git checkout transgform-php-laravel
```

## Verify You Have Everything

```bash
# Check required files exist
cd ~/Projects/email-signature-generator

# Must exist:
ls docker-compose.yml        # Docker config
ls composer.json             # Laravel project file
ls artisan                   # Laravel CLI
ls .env.example              # Environment template

# If all 4 files exist, you're ready to continue with setup!
```

## Next Steps

Once you have the files:

1. ✅ docker-compose.yml copied to WSL
2. ✅ Laravel project files copied to WSL
3. 📖 Continue with [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) from Step 3
4. 📋 Use [CHECKLIST.md](CHECKLIST.md) to track progress

## Need Help?

- Files won't copy? Make sure WSL can access Windows: `/mnt/c/`
- Permission errors? Run: `chmod -R 755 ~/Projects/email-signature-generator`
- Docker Desktop not found in WSL? Check Docker Desktop → Settings → WSL Integration
