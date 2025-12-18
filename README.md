# Email Signature Generator

A professional email signature generator built with Laravel 12, PHP 8.2+, Eloquent ORM, and MySQL 8.0.

> ✅ **WSL Compatible** - Fully tested and working on Windows WSL 2, macOS, and Linux

> ⚠️ **IMPORTANT - Read First:** 
> - MySQL runs in Docker (NO Dockerfile needed - uses official MySQL image)
> - Laravel runs locally with `php artisan serve` (NOT in Docker)
> - Don't try to build any Docker images - just run `docker-compose up -d`
> - See [ARCHITECTURE.md](ARCHITECTURE.md) for visual explanation

## 🚀 Quick Start for Students

**📚 Documentation:**
- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Complete step-by-step setup guide
- **[WSL_SETUP.md](WSL_SETUP.md)** - Windows WSL specific instructions
- **[CHECKLIST.md](CHECKLIST.md)** - Printable setup checklist
- **[DOCKER_SETUP.md](DOCKER_SETUP.md)** - Docker architecture explanation
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Visual system architecture

**Windows WSL Users:** 
- All commands should be run in **WSL terminal (Ubuntu)**, not PowerShell or CMD
- See [WSL_SETUP.md](WSL_SETUP.md) for specific instructions
- Use [CHECKLIST.md](CHECKLIST.md) to track your progress

### Quick Setup Summary

```bash
# 1. Start MySQL in Docker
docker-compose up -d

# 2. Install dependencies
composer install

# 3. Configure environment
cp .env.example .env
php artisan key:generate

# 4. Run migrations
php artisan migrate
php artisan db:seed --class=TemplateSeeder

# 5. Start server
php artisan serve --port=8080
```

Open browser: **http://localhost:8080**

## 📚 Documentation

**Start Here:**
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - ⭐ Visual guide: What runs where? (Read this first!)
- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Complete setup guide with troubleshooting

**Additional Resources:**
- **[PROJECT_SETUP.md](PROJECT_SETUP.md)** - Detailed project structure
- **[DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)** - Database schema with visual diagrams

## Tech Stack

- **Backend**: Laravel 12, PHP 8.2+
- **Database**: MySQL 8.0
- **ORM**: Eloquent
- **Authentication**: Laravel Sanctum (API Token Authentication)
- **Frontend**: Vanilla JavaScript, HTML, CSS
- **Package Manager**: Composer (PHP), NPM (JavaScript)
- **Containerization**: Docker & Docker Compose

## Features

- User authentication (register, login, logout)
- User profiles with customizable information
- Multiple email signature templates
- Signature creation and customization
- HTML signature export
- Role-based access (student, admin)
- RESTful API architecture

## Project Structure

```
.
├── app/
│   ├── Http/Controllers/Api/  # API Controllers
│   │   ├── AuthController.php
│   │   ├── ProfileController.php
│   │   ├── SignatureController.php
│   │   └── TemplateController.php
│   └── Models/                # Eloquent Models
│       ├── User.php
│       ├── Profile.php
│       ├── Template.php
│       └── Signature.php
├── database/
│   ├── migrations/            # Database migrations
│   └── seeders/              # Database seeders
├── public/                   # Frontend assets
├── routes/
│   ├── api.php              # API routes
│   └── web.php              # Web routes
└── docker-compose.yml       # Docker configuration
```

## Installation

### Prerequisites

- PHP 8.2+
- Composer
- MySQL 8.0+
- Node.js & NPM (optional)
- Docker & Docker Compose (optional)

### Local Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd email-signature-generator
   ```

2. **Install dependencies**
   ```bash
   composer install
   npm install  # Optional
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. **Update .env file**
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=email_signature_db
   DB_USERNAME=root
   DB_PASSWORD=
   ```

5. **Run migrations and seeders**
   ```bash
   php artisan migrate
   php artisan db:seed --class=TemplateSeeder
   ```

6. **Start the development server**
   ```bash
   php artisan serve
   ```

   The application will be available at `http://localhost:8000`

### Docker Setup

1. **Start containers**
   ```bash
   docker-compose up -d
   ```

2. **The application will be available at `http://localhost:8000`**

## API Endpoints

### Authentication
- `POST /api/register` - Register new user
- `POST /api/login` - Login user
- `POST /api/logout` - Logout user (authenticated)

### Profile
- `GET /api/profile` - Get user profile (authenticated)
- `PUT /api/profile` - Update user profile (authenticated)

### Templates
- `GET /api/templates` - Get all public templates (authenticated)
- `GET /api/templates/{id}` - Get specific template (authenticated)
- `POST /api/templates` - Create template (admin only)

### Signatures
- `GET /api/signatures` - Get user signatures (authenticated)
- `POST /api/signatures` - Create signature (authenticated)
- `GET /api/signatures/{id}` - Get specific signature (authenticated)
- `PUT /api/signatures/{id}` - Update signature (authenticated)
- `DELETE /api/signatures/{id}` - Delete signature (authenticated)
- `GET /api/signatures/{id}/export` - Export signature as HTML (authenticated)

## Database Schema

### Users
- id, email, password, full_name, role, timestamps

### Profiles
- id, user_id, job_title, phone, website, avatar_url, timestamps

### Templates
- id, name, html_template, thumbnail_url, is_public, timestamps

### Signatures
- id, user_id, template_id, data (JSON), html_rendered, timestamps

## Development

### Running Tests
```bash
php artisan test
```

### Code Style
```bash
./vendor/bin/pint
```

### Database Operations
```bash
# Fresh migration
php artisan migrate:fresh

# Rollback
php artisan migrate:rollback

# Seed database
php artisan db:seed
```

## License

MIT License
