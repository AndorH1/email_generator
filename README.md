# Email Signature Generator

A full-stack web application for creating, managing, and exporting professional email signatures. Built as a student project demonstrating modern web development practices with FastAPI, MySQL, and vanilla JavaScript.

## 📋 Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [API Overview](#api-overview)
- [Contributing](#contributing)
- [Support](#support)

---

## 🎯 Features

- **User Authentication**: JWT-based secure login and registration with Remember Me
- **Profile Management**: Store personal information for quick signature creation
- **Template Library**: 6+ professional email signature templates
- **Live Preview**: Real-time signature preview while editing
- **Export Options**: Copy HTML or download signature files
- **Full CRUD Operations**: Create, read, update, and delete signatures
- **Responsive Design**: Works on desktop and mobile devices
- **Role-Based Access**: Student and Admin roles with different permissions

---

## 🛠 Technology Stack

### Backend
- **Framework**: FastAPI 0.104.1 (Python 3.11+)
- **Database**: MySQL 8.0
- **ORM**: SQLAlchemy 2.0.23
- **Authentication**: JWT tokens + bcrypt password hashing
- **Server**: Uvicorn ASGI server

### Frontend
- **HTML5** + **CSS3** (Bootstrap 5)
- **JavaScript**: Vanilla ES6+ (no framework)
- **Session**: localStorage for client-side persistence
- **HTTP Server**: npx http-server for development

### Infrastructure
- **Containerization**: Docker + Docker Compose
- **Database Migrations**: SQL scripts
- **Version Control**: Git

---

## 🚀 Quick Start

### Using Docker (Recommended)

```bash
# 1. Clone the repository
git clone https://github.com/AndorH1/email_generator.git
cd email_generator

# 2. Create and configure environment file
cp .env.example .env
# Edit .env and set secure passwords

# 3. Start all services
docker-compose up -d

# 4. Initialize database
docker exec -i email_signature_db mysql -uroot -p$(grep MYSQL_ROOT_PASSWORD .env | cut -d '=' -f2) email_signature_db < database/schema.sql
docker exec -i email_signature_db mysql -uroot -p$(grep MYSQL_ROOT_PASSWORD .env | cut -d '=' -f2) email_signature_db < database/seed_data.sql

# 5. Start frontend
npx http-server ./frontend -p 3000 -c-1
```

**Access the application:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

**Test Credentials:**
- Email: `john.doe@example.com`
- Password: `password123`

### Using Docker Hub

```bash
# Pull pre-built image
docker pull could198/email-signature-generator:latest

# Run with docker-compose
docker-compose up -d
```

📖 **For detailed setup instructions, see [docs/SETUP.md](docs/SETUP.md)**

---

## 📚 Documentation

For detailed guides and references, see the `docs/` folder:

- **[SETUP.md](docs/SETUP.md)** - Complete setup guide with step-by-step instructions
- **[MIGRATION.md](docs/MIGRATION.md)** - Database migration and upgrade guide
- **[USER_PERSISTENCE.md](docs/USER_PERSISTENCE.md)** - Session management and authentication details

### Project Structure

```
email-signature-generator/
├── backend/              # FastAPI backend
│   ├── app/
│   │   ├── api/         # API endpoints
│   │   ├── core/        # Configuration & security
│   │   ├── models/      # Database models
│   │   └── schemas/     # Pydantic schemas
│   └── Dockerfile
├── frontend/            # Static HTML/CSS/JS
│   ├── js/              # Application logic
│   ├── css/             # Styles
│   └── *.html           # Pages
├── database/            # SQL schemas and seed data
├── docs/                # Documentation
└── docker-compose.yml   # Docker orchestration
```

---

## 📡 API Overview

### Key Endpoints

**Authentication:**
- `POST /api/register` - Create new user account
- `POST /api/login` - Login and get JWT token

**User Profile:**
- `GET /api/profile` - Get user profile
- `PUT /api/profile` - Update profile information

**Templates:**
- `GET /api/templates` - List all templates

**Signatures:**
- `GET /api/signatures` - List user signatures
- `POST /api/signatures` - Create new signature
- `PUT /api/signatures/{id}` - Update existing signature
- `DELETE /api/signatures/{id}` - Delete signature
- `GET /api/signatures/{id}/export` - Export HTML

**Interactive Documentation:** http://localhost:8000/docs

---

## 🐳 Docker Commands

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Restart backend
docker-compose restart backend

# Stop all services
docker-compose down

# Rebuild images
docker-compose up -d --build
```

---

## 🧪 Testing

**Backend Health Check:**
```bash
curl http://localhost:8000/health
```

**Test Login:**
```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john.doe@example.com","password":"password123"}'
```

**Frontend:** Open http://localhost:3000 in browser and test all features.

---

## 🤝 Contributing

This is a student project. Contributions, issues, and feature requests are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📞 Support

- **Documentation**: See `docs/` folder for detailed guides
- **Issues**: Open an issue on GitHub
- **API Reference**: http://localhost:8000/docs

---

## 🙏 Acknowledgments

Built with:
- [FastAPI](https://fastapi.tiangolo.com/) - Modern Python web framework
- [Bootstrap](https://getbootstrap.com/) - UI framework
- [MySQL](https://www.mysql.com/) - Database
- [Docker](https://www.docker.com/) - Containerization

---

**Repository:** https://github.com/AndorH1/email_generator  
**Docker Image:** could198/email-signature-generator  
**Version:** 1.0.0  
**Last Updated:** November 25, 2024
