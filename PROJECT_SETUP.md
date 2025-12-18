# Email Signature Generator - Project Setup Guide

A complete guide for students to build this Laravel-based email signature generator from scratch.

> **For Windows Users:** This project uses WSL (Windows Subsystem for Linux). All terminal commands should be run in your WSL terminal (Ubuntu). See [WSL Setup for Windows](#wsl-setup-for-windows) section below.

## 📋 Table of Contents
- [WSL Setup for Windows](#wsl-setup-for-windows) *(Windows users start here)*
- [Prerequisites](#prerequisites)
- [Technologies Used](#technologies-used)
- [Project Setup](#project-setup)
- [Database Configuration](#database-configuration)
- [Application Structure](#application-structure)
- [Testing the Application](#testing-the-application)
- [Troubleshooting](#troubleshooting)

---

## WSL Setup for Windows

**Windows users must complete this section first before continuing.**

### Step 1: Install WSL 2

1. Open **PowerShell as Administrator**:
   - Press `Win + X`
   - Click "Windows PowerShell (Admin)" or "Terminal (Admin)"

2. Install WSL with Ubuntu:
   ```powershell
   wsl --install
   ```
   This installs WSL 2 with Ubuntu as the default distribution.

3. **Restart your computer** (required!)

4. After restart, open PowerShell again and set WSL 2 as default:
   ```powershell
   wsl --set-default-version 2
   ```

5. **Set up your Ubuntu username and password:**
   - Ubuntu will automatically launch after install
   - Create a username (all lowercase, no spaces)
   - Create a password (you won't see it as you type - this is normal)
   - Remember these credentials!

### Step 2: Verify WSL Installation

Open **Ubuntu** from the Start Menu (or type `wsl` in PowerShell):

```bash
# Check WSL version (should show version 2)
wsl --version

# Update Ubuntu packages
sudo apt update && sudo apt upgrade -y
```

### Step 3: Install Docker Desktop with WSL Integration

1. Download Docker Desktop: https://www.docker.com/products/docker-desktop/
2. Install and restart your computer
3. After restart, open **Docker Desktop**
4. Enable WSL integration:
   - Click Settings (gear icon) → Resources → WSL Integration
   - Enable "Enable integration with my default WSL distro"
   - Enable "Ubuntu" toggle
   - Click "Apply & Restart"

5. Verify Docker in WSL:
   ```bash
   # Open Ubuntu terminal and run:
   docker --version
   docker-compose --version
   ```

### Step 4: Access Your Files in WSL

**Important:** Work in your WSL home directory, not Windows directories (for better performance).

```bash
# Your WSL home directory
cd ~

# Create a projects folder
mkdir -p ~/Projects
cd ~/Projects

# Your Windows files are accessible at /mnt/c/
# Example: /mnt/c/Users/YourName/Documents
```

**Opening VS Code in WSL:**
```bash
# Install VS Code on Windows first
# Then from WSL terminal:
cd ~/Projects/email-signature-generator
code .
# This opens VS Code with WSL integration
```

---

## Prerequisites

Before starting, ensure you have the following installed:

**For Windows users:** Install everything below **inside WSL** (Ubuntu terminal), not in Windows directly.

### Required Software

1. **PHP 8.2 or higher**
   ```bash
   # Check PHP version
   php -v
   
   # macOS: Install via Homebrew
   brew install php@8.2
   
   # Ubuntu/Debian
   sudo apt update
   sudo apt install php8.2 php8.2-cli php8.2-mbstring php8.2-xml php8.2-curl php8.2-mysql
   ```

2. **Composer** (PHP dependency manager)
   ```bash
   # Download and install
   curl -sS https://getcomposer.org/installer | php
   sudo mv composer.phar /usr/local/bin/composer
   
   # Verify installation
   composer --version
   ```

3. **MySQL 8.0** (Database)
   ```bash
   # macOS
   brew install mysql
   brew services start mysql
   
   # Ubuntu/Debian
   sudo apt install mysql-server
   sudo systemctl start mysql
   
   # OR use Docker (recommended for easy setup)
   docker pull mysql:8.0
   docker run --name email-signature-mysql \
     -e MYSQL_ROOT_PASSWORD=password \
     -e MYSQL_DATABASE=email_signature_db \
     -p 3306:3306 \
     -d mysql:8.0
   ```

4. **Docker** (Optional - for containerized setup)
   
   **Windows:**
   ```bash
   # Download and install Docker Desktop from:
   # https://www.docker.com/products/docker-desktop/
   
   # After installation, open PowerShell or Command Prompt and verify:
   docker --version
   docker-compose --version
   
   # Make sure Docker Desktop is running (check system tray icon)
   ```
   
   **macOS:**
   ```bash
   # Download Docker Desktop from: https://www.docker.com/products/docker-desktop/
   # Or install via Homebrew:
   brew install --cask docker
   
   # Verify installation
   docker --version
   docker-compose --version
   ```
   
   **Ubuntu/Debian (Linux):**
   ```bash
   sudo apt install docker.io docker-compose
   
   # Verify installation
   docker --version
   docker-compose --version
   ```

5. **Node.js & NPM** (For frontend assets)
   ```bash
   # macOS
   brew install node
   
   # Ubuntu/Debian
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt install nodejs
   
   # Verify installation
   node -v
   npm -v
   ```

---

## Technologies Used

### Backend
- **Laravel 12** - PHP web framework
- **Laravel Sanctum** - API authentication
- **Laravel Pint** - Code style formatter
- **PHPUnit** - Testing framework
- **Eloquent ORM** - Database interaction

### Frontend
- **HTML5/CSS3** - Structure and styling
- **Bootstrap 5** - UI framework
- **JavaScript (Vanilla)** - Client-side logic
- **Fetch API** - HTTP requests

### Database
- **MySQL 8.0** - Relational database

---

## Project Setup

### Option A: Using Docker (Quickstart)

If you want to quickly start with a pre-configured environment, use the Docker image.

> **Note for Windows Users:** Make sure Docker Desktop is running before executing these commands. You can check the Docker icon in your system tray.

> **⚠️ Important:** If you get "no matching manifest for linux/amd64" error, the Docker image needs to be rebuilt with multi-platform support. See the troubleshooting section below or use Option B to build locally.

**Pull the Docker image from Docker Hub:**

```bash
# Works on Windows (PowerShell/CMD), macOS, and Linux
docker pull could198/email-signature-generator:latest
```

**Quick Run (Single Container):**

```bash
# Windows (PowerShell/CMD)
docker run -d --name email-signature-app -p 8080:8080 -e DB_HOST=host.docker.internal -e DB_DATABASE=email_signature_db -e DB_USERNAME=root -e DB_PASSWORD=password could198/email-signature-generator:latest

# macOS/Linux (bash/zsh)
docker run -d \
  --name email-signature-app \
  -p 8080:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_DATABASE=email_signature_db \
  -e DB_USERNAME=root \
  -e DB_PASSWORD=password \
  could198/email-signature-generator:latest

# Access the application at http://localhost:8080
```

**With Docker Compose (Recommended for All Platforms):**

Create a `docker-compose.yml` file in your project directory:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: email-signature-mysql
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: email_signature_db
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

  app:
    image: could198/email-signature-generator:latest
    container_name: email-signature-app
    ports:
      - "8080:8080"
    environment:
      DB_HOST: mysql
      DB_PORT: 3306
      DB_DATABASE: email_signature_db
      DB_USERNAME: root
      DB_PASSWORD: password
      APP_URL: http://localhost:8080
    depends_on:
      - mysql

volumes:
  mysql_data:
```

**Windows Users:** Open WSL terminal and create the file:
```bash
# In WSL terminal (Ubuntu)
cd ~/Projects/email-signature-generator  # Or your project location

# Create the docker-compose.yml file using nano or vim
nano docker-compose.yml
# Paste the content above, then press Ctrl+X, Y, Enter to save

# Or use VS Code from WSL
code docker-compose.yml
```

**Then run (in WSL terminal for Windows, or regular terminal for macOS/Linux):**

```bash
# Start all services
docker-compose up -d

# Check if containers are running
docker-compose ps

# Run migrations (first time only)
docker-compose exec app php artisan migrate

# Seed templates (first time only)
docker-compose exec app php artisan db:seed --class=TemplateSeeder

# View logs
docker-compose logs -f app

# Stop services
docker-compose down

# Stop and remove all data
docker-compose down -v
```

**Accessing the Application:**
- Open your browser (Chrome, Firefox, Edge)
- Navigate to: **http://localhost:8080**
- Register a new account to get started!

### Option B: Manual Setup (From Scratch)

If you want to build the project from scratch for learning purposes:

#### Step 1: Create New Laravel Project

```bash
# Navigate to your projects directory
cd ~/Projects

# Create a new Laravel 12 project
composer create-project laravel/laravel email-signature-generator

# Navigate into the project
cd email-signature-generator
```

#### Step 2: Install Laravel Packages

```bash
# Install Laravel Sanctum for API authentication
composer require laravel/sanctum

# Install Laravel Pint for code formatting
composer require laravel/pint --dev

# Install Laravel Boost for enhanced development (optional)
composer require laravel/boost --dev
```

#### Step 3: Configure Environment

```bash
# Copy the example environment file
cp .env.example .env

# Generate application key
php artisan key:generate
```

Edit the `.env` file with your database credentials:

```env
APP_NAME="Email Signature Generator"
APP_ENV=local
APP_KEY=base64:... # Auto-generated
APP_DEBUG=true
APP_URL=http://localhost:8080

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=email_signature_db
DB_USERNAME=root
DB_PASSWORD=

SESSION_DRIVER=file
CACHE_STORE=file
QUEUE_CONNECTION=sync
```

---

## Database Configuration

### Step 1: Create Database

```bash
# Login to MySQL
mysql -u root -p

# Create database
CREATE DATABASE email_signature_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Exit MySQL
EXIT;
```

### Step 2: Create Database Migrations

```bash
# Create profiles migration
php artisan make:migration create_profiles_table

# Create templates migration
php artisan make:migration create_templates_table

# Create signatures migration
php artisan make:migration create_signatures_table
```

#### Edit `database/migrations/XXXX_create_profiles_table.php`:

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('job_title')->nullable();
            $table->string('phone')->nullable();
            $table->string('website')->nullable();
            $table->text('avatar_url')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('profiles');
    }
};
```

#### Edit `database/migrations/XXXX_create_templates_table.php`:

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('templates', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('html_template');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('templates');
    }
};
```

#### Edit `database/migrations/XXXX_create_signatures_table.php`:

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('signatures', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('template_id')->constrained()->onDelete('cascade');
            $table->json('data');
            $table->text('html_rendered');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('signatures');
    }
};
```

### Step 3: Run Migrations

```bash
# Publish Sanctum migrations
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Run all migrations
php artisan migrate
```

### Step 4: Seed Database with Templates

Create a seeder:

```bash
php artisan make:seeder TemplateSeeder
```

Edit `database/seeders/TemplateSeeder.php`:

```php
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class TemplateSeeder extends Seeder
{
    public function run(): void
    {
        $templates = [
            [
                'name' => 'Classic Professional',
                'html_template' => '<table cellpadding="0" cellspacing="0" style="font-family:Arial, sans-serif; font-size:14px; line-height:1.4;">
        <tr>
            <td style="padding-right:16px; vertical-align:top;">
                <img src="{{avatar_url}}" alt="Profile" width="80" height="80" style="border-radius:8px; display:block;">
            </td>
            <td style="vertical-align:top;">
                <div style="font-weight:700; font-size:16px; color:#333; margin-bottom:4px;">{{full_name}}</div>
                <div style="color:{{accent_color}}; font-size:13px; margin-bottom:8px;">{{job_title}}</div>
                <div style="color:#666; font-size:13px;">
                    <div style="margin-bottom:3px;">Phone: <a href="tel:{{phone}}" style="color:#666; text-decoration:none;">{{phone}}</a></div>
                    <div>Web: <a href="{{website}}" style="color:{{accent_color}}; text-decoration:none;">{{website}}</a></div>
                </div>
            </td>
        </tr>
    </table>',
            ],
            [
                'name' => 'Modern Minimal',
                'html_template' => '<table cellpadding="0" cellspacing="0" style="font-family:\'Helvetica Neue\', Helvetica, Arial, sans-serif; font-size:14px;">
        <tr>
            <td>
                <div style="font-weight:600; font-size:18px; color:#1a1a1a; margin-bottom:2px;">{{full_name}}</div>
                <div style="font-size:14px; color:{{accent_color}}; margin-bottom:12px;">{{job_title}}</div>
                <div style="border-top:2px solid {{accent_color}}; padding-top:12px;">
                    <div style="color:#666; font-size:13px; margin-bottom:4px;">{{phone}}</div>
                    <div><a href="{{website}}" style="color:{{accent_color}}; text-decoration:none; font-size:13px;">{{website}}</a></div>
                </div>
            </td>
        </tr>
    </table>',
            ],
            [
                'name' => 'Compact Business',
                'html_template' => '<table cellpadding="0" cellspacing="0" style="font-family:Arial, sans-serif; font-size:13px; border-left:3px solid {{accent_color}}; padding-left:12px;">
        <tr>
            <td>
                <div style="font-weight:700; font-size:15px; color:#222; margin-bottom:3px;">{{full_name}}</div>
                <div style="font-size:13px; color:#666; margin-bottom:8px;">{{job_title}}</div>
                <div style="font-size:12px; color:#888;">
                    <span style="margin-right:10px;">T: <a href="tel:{{phone}}" style="color:#888; text-decoration:none;">{{phone}}</a></span>
                    <span>W: <a href="{{website}}" style="color:{{accent_color}}; text-decoration:none;">{{website}}</a></span>
                </div>
            </td>
        </tr>
    </table>',
            ],
        ];

        DB::table('templates')->insert($templates);
    }
}
```

Run the seeder:

```bash
php artisan db:seed --class=TemplateSeeder
```

---

## Application Structure

### Step 5: Create Models

```bash
# Create models with factories
php artisan make:model Profile
php artisan make:model Template
php artisan make:model Signature
```

#### `app/Models/Profile.php`:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Profile extends Model
{
    protected $fillable = [
        'user_id',
        'job_title',
        'phone',
        'website',
        'avatar_url',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

#### `app/Models/Template.php`:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Template extends Model
{
    protected $fillable = [
        'name',
        'html_template',
    ];

    public function signatures(): HasMany
    {
        return $this->hasMany(Signature::class);
    }
}
```

#### `app/Models/Signature.php`:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Signature extends Model
{
    protected $fillable = [
        'user_id',
        'template_id',
        'data',
        'html_rendered',
    ];

    protected function casts(): array
    {
        return [
            'data' => 'array',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function template(): BelongsTo
    {
        return $this->belongsTo(Template::class);
    }
}
```

#### Update `app/Models/User.php`:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function profile(): HasOne
    {
        return $this->hasOne(Profile::class);
    }

    public function signatures(): HasMany
    {
        return $this->hasMany(Signature::class);
    }
}
```

### Step 6: Create Controllers

```bash
# Create API controllers
php artisan make:controller Api/AuthController
php artisan make:controller Api/ProfileController
php artisan make:controller Api/TemplateController
php artisan make:controller Api/SignatureController
php artisan make:controller Api/ImageProxyController
```

#### `app/Http/Controllers/Api/AuthController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Profile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email|unique:users',
            'password' => 'required|min:6',
            'full_name' => 'required|string|max:255',
        ]);

        $user = User::create([
            'name' => $validated['full_name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
        ]);

        Profile::create([
            'user_id' => $user->id,
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $validated['email'])->first();

        if (!$user || !Hash::check($validated['password'], $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logged out successfully']);
    }
}
```

#### `app/Http/Controllers/Api/ProfileController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        $profile = $request->user()->profile;

        return response()->json([
            'full_name' => $request->user()->name,
            'job_title' => $profile->job_title,
            'phone' => $profile->phone,
            'website' => $profile->website,
            'avatar_url' => $profile->avatar_url,
        ]);
    }

    public function update(Request $request)
    {
        $validated = $request->validate([
            'full_name' => 'sometimes|string|max:255',
            'job_title' => 'sometimes|string|max:255',
            'phone' => 'sometimes|string|max:50',
            'website' => 'sometimes|url|max:255',
            'avatar_url' => 'sometimes|string',
        ]);

        $user = $request->user();
        $profile = $user->profile;

        if (isset($validated['full_name'])) {
            $user->name = $validated['full_name'];
            $user->save();
        }

        $profile->update([
            'job_title' => $validated['job_title'] ?? $profile->job_title,
            'phone' => $validated['phone'] ?? $profile->phone,
            'website' => $validated['website'] ?? $profile->website,
            'avatar_url' => $validated['avatar_url'] ?? $profile->avatar_url,
        ]);

        return response()->json([
            'message' => 'Profile updated successfully',
            'profile' => [
                'full_name' => $user->name,
                'job_title' => $profile->job_title,
                'phone' => $profile->phone,
                'website' => $profile->website,
                'avatar_url' => $profile->avatar_url,
            ],
        ]);
    }
}
```

#### `app/Http/Controllers/Api/TemplateController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Template;

class TemplateController extends Controller
{
    public function index()
    {
        return Template::all();
    }

    public function show($id)
    {
        return Template::findOrFail($id);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'html_template' => 'required|string',
        ]);

        $template = Template::create($validated);

        return response()->json($template, 201);
    }
}
```

#### `app/Http/Controllers/Api/SignatureController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Signature;
use App\Models\Template;
use Illuminate\Http\Request;

class SignatureController extends Controller
{
    public function index(Request $request)
    {
        return $request->user()->signatures()
            ->with('template')
            ->latest()
            ->get();
    }

    public function show(Request $request, $id)
    {
        $signature = $request->user()
            ->signatures()
            ->with('template')
            ->findOrFail($id);

        return response()->json($signature);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'template_id' => 'required|exists:templates,id',
            'data' => 'required|array',
        ]);

        $template = Template::findOrFail($validated['template_id']);
        $htmlRendered = $this->renderTemplate($template->html_template, $validated['data']);

        $signature = $request->user()->signatures()->create([
            'template_id' => $validated['template_id'],
            'data' => $validated['data'],
            'html_rendered' => $htmlRendered,
        ]);

        return response()->json($signature, 201);
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'template_id' => 'required|exists:templates,id',
            'data' => 'required|array',
        ]);

        $signature = $request->user()->signatures()->findOrFail($id);
        $template = Template::findOrFail($validated['template_id']);
        $htmlRendered = $this->renderTemplate($template->html_template, $validated['data']);

        $signature->update([
            'template_id' => $validated['template_id'],
            'data' => $validated['data'],
            'html_rendered' => $htmlRendered,
        ]);

        return response()->json($signature);
    }

    public function destroy(Request $request, $id)
    {
        $signature = $request->user()->signatures()->findOrFail($id);
        $signature->delete();

        return response()->json(['message' => 'Signature deleted successfully']);
    }

    public function export(Request $request, $id)
    {
        $signature = $request->user()->signatures()->findOrFail($id);

        return response($signature->html_rendered)
            ->header('Content-Type', 'text/html');
    }

    private function renderTemplate(string $template, array $data): string
    {
        $html = $template;

        foreach ($data as $key => $value) {
            $html = str_replace("{{{$key}}}", $value, $html);
        }

        return $html;
    }
}
```

#### `app/Http/Controllers/Api/ImageProxyController.php`:

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ImageProxyController extends Controller
{
    public function proxy(Request $request)
    {
        $url = $request->query('url');
        
        if (!$url || !filter_var($url, FILTER_VALIDATE_URL)) {
            return response()->json(['error' => 'Invalid URL'], 400);
        }

        try {
            $response = Http::timeout(10)
                ->withHeaders([
                    'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                    'Referer' => 'https://imgur.com/',
                ])
                ->get($url);

            if ($response->successful()) {
                return response($response->body())
                    ->header('Content-Type', $response->header('Content-Type'))
                    ->header('Cache-Control', 'public, max-age=86400')
                    ->header('Access-Control-Allow-Origin', '*');
            }

            return response()->json(['error' => 'Failed to fetch image'], $response->status());
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch image: ' . $e->getMessage()], 500);
        }
    }
}
```

### Step 7: Configure Routes

Edit `routes/api.php`:

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\TemplateController;
use App\Http\Controllers\Api\SignatureController;
use App\Http\Controllers\Api\ImageProxyController;

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/image-proxy', [ImageProxyController::class, 'proxy']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::put('/profile', [ProfileController::class, 'update']);
    
    Route::get('/templates', [TemplateController::class, 'index']);
    Route::get('/templates/{id}', [TemplateController::class, 'show']);
    Route::post('/templates', [TemplateController::class, 'store']);
    
    Route::get('/signatures', [SignatureController::class, 'index']);
    Route::post('/signatures', [SignatureController::class, 'store']);
    Route::get('/signatures/{id}', [SignatureController::class, 'show']);
    Route::put('/signatures/{id}', [SignatureController::class, 'update']);
    Route::delete('/signatures/{id}', [SignatureController::class, 'destroy']);
    Route::get('/signatures/{id}/export', [SignatureController::class, 'export']);
});
```

Edit `routes/web.php`:

```php
<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->file(public_path('index.html'));
});

Route::get('/login', function () {
    return response()->file(public_path('login.html'));
});

Route::get('/register', function () {
    return response()->file(public_path('register.html'));
});

Route::get('/dashboard', function () {
    return response()->file(public_path('dashboard.html'));
});

Route::get('/editor', function () {
    return response()->file(public_path('editor.html'));
});

Route::get('/profile', function () {
    return response()->file(public_path('profile.html'));
});
```

### Step 8: Configure CORS

Edit `config/cors.php`:

```php
<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

Edit `bootstrap/app.php`:

```php
<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__ . '/../routes/web.php',
        api: __DIR__ . '/../routes/api.php',
        commands: __DIR__ . '/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->api(prepend: [
            \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
        ]);

        $middleware->validateCsrfTokens(except: [
            'api/*',
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })->create();
```

### Step 9: Create Frontend Files

Create the following files in the `public` directory. Download or copy them from the repository:

**Frontend Structure:**
```
public/
├── index.html          # Landing page
├── login.html          # Login page
├── register.html       # Registration page
├── dashboard.html      # User dashboard
├── editor.html         # Signature editor
├── profile.html        # User profile
├── css/
│   └── style.css       # Custom styles
└── js/
    ├── config.js       # API configuration
    ├── main.js         # Global utilities
    ├── auth.js         # Authentication logic
    ├── dashboard.js    # Dashboard logic
    ├── editor.js       # Editor logic
    └── profile.js      # Profile logic
```

**Note:** The frontend files are too large to include here. You can either:
1. Copy them from the repository
2. Create them based on the API structure (examples below)

#### Key Frontend Files:

**`public/js/config.js`:**
```javascript
const API_BASE_URL = window.location.hostname === 'localhost' 
    ? `http://${window.location.hostname}:${window.location.port || 8080}/api`
    : '/api';

const API_ENDPOINTS = {
    register: `${API_BASE_URL}/register`,
    login: `${API_BASE_URL}/login`,
    logout: `${API_BASE_URL}/logout`,
    profile: `${API_BASE_URL}/profile`,
    templates: `${API_BASE_URL}/templates`,
    signatures: `${API_BASE_URL}/signatures`,
    signatureDetail: (id) => `${API_BASE_URL}/signatures/${id}`,
    signatureExport: (id) => `${API_BASE_URL}/signatures/${id}/export`,
};
```

---

## Testing the Application

### Step 1: Start the Development Server

```bash
# Clear all caches
php artisan config:clear
php artisan route:clear
php artisan cache:clear

# Start the server on port 8080
php artisan serve --port=8080
```

### Step 2: Access the Application

Open your browser and navigate to:
- **Homepage:** http://localhost:8080
- **Login:** http://localhost:8080/login
- **Register:** http://localhost:8080/register

### Step 3: Test User Registration

1. Go to http://localhost:8080/register
2. Fill in:
   - Full Name: `Test User`
   - Email: `test@example.com`
   - Password: `password123`
3. Click "Register"
4. You should be redirected to the dashboard

### Step 4: Test Signature Creation

1. Click "Create New Signature"
2. Select a template
3. Fill in your details
4. Click "Update Preview" to see the result
5. Click "Save Signature"

### Step 5: Test Profile Update

1. Go to Profile page
2. Update your information
3. Save changes
4. Verify updates in the editor

---

## Docker Commands Reference

### Managing Docker Containers

```bash
# View running containers
docker ps

# View all containers (including stopped)
docker ps -a

# View container logs
docker logs email-signature-app
docker logs -f email-signature-app  # Follow logs

# Access container shell
docker exec -it email-signature-app bash

# Stop container
docker stop email-signature-app

# Start container
docker start email-signature-app

# Remove container
docker rm email-signature-app

# Remove image
docker rmi could198/email-signature-generator:latest
```

### Pushing Your Own Image to Docker Hub

If you want to create and push your own version:

**Option 1: Multi-Platform Build (Recommended for Cross-Platform Compatibility)**

This creates images that work on both Windows (AMD64) and Mac M1/M2 (ARM64):

```bash
# First time setup - create builder
docker buildx create --name multiplatform --use
docker buildx inspect --bootstrap

# Login to Docker Hub
docker login

# Build and push for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t could198/email-signature-generator:latest \
  -t could198/email-signature-generator:v1.0.0 \
  --push \
  .

# Verify the image supports both platforms
docker buildx imagetools inspect could198/email-signature-generator:latest
```

**Option 2: Single Platform Build (Quick but Limited)**

Only works on the platform you built it on:

```bash
# Build for your current platform only
docker build -t your-username/email-signature-generator:tagname .

# Login to Docker Hub
docker login

# Push to Docker Hub
docker push your-username/email-signature-generator:tagname
```

**Why Multi-Platform Matters:**
- Mac M1/M2 uses ARM64 architecture
- Windows/Intel Macs use AMD64 (x86_64) architecture
- Without multi-platform build, Windows users get: `no matching manifest for linux/amd64`

### Database Management with Docker

```bash
# Access MySQL in Docker container
docker exec -it email-signature-mysql mysql -u root -p

# Backup database
docker exec email-signature-mysql mysqldump -u root -ppassword email_signature_db > backup.sql

# Restore database
docker exec -i email-signature-mysql mysql -u root -ppassword email_signature_db < backup.sql

# View MySQL logs
docker logs email-signature-mysql
```

---

## Troubleshooting

### Common Issues

#### 1. **Port Already in Use**
```bash
# Find process using port 8080
lsof -i :8080

# Kill the process
kill -9 <PID>

# Or use a different port
php artisan serve --port=8000
```

#### 2. **Database Connection Failed**
```bash
# Verify MySQL is running
mysql -u root -p

# Check .env database credentials
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=email_signature_db
DB_USERNAME=root
DB_PASSWORD=your_password
```

#### 3. **CORS Errors**
```bash
# Clear config cache
php artisan config:clear

# Restart server
php artisan serve --port=8080
```

#### 4. **Images Not Loading**
- The application uses an image proxy to avoid CORS issues
- External images are automatically proxied through `/api/image-proxy`
- Use data URIs for guaranteed compatibility in email clients

#### 5. **Migration Errors**
```bash
# Reset database and re-run migrations
php artisan migrate:fresh

# Seed templates again
php artisan db:seed --class=TemplateSeeder
```

---

### Docker Desktop on Windows - Specific Issues

#### Issue: "Docker Desktop requires WSL 2"
**Solution:** Install Windows Subsystem for Linux 2 (required for this project):

1. Open PowerShell as Administrator (Right-click Start → Windows PowerShell (Admin))
2. Run: `wsl --install`
3. Restart your computer
4. After restart, set WSL 2 as default:
   ```powershell
   wsl --set-default-version 2
   ```
5. Enable WSL integration in Docker Desktop:
   - Open Docker Desktop → Settings → Resources → WSL Integration
   - Toggle on "Enable integration with my default WSL distro"
   - Toggle on your Ubuntu (or other distro)
   - Click "Apply & Restart"

**If automatic install fails:**
- Download WSL 2 kernel update: https://aka.ms/wsl2kernel
- Install the downloaded file
- Run the commands above

#### Issue: "Hardware assisted virtualization not enabled"
**Solution:** Enable virtualization in BIOS:
1. Restart computer and enter BIOS setup:
   - **Dell/HP:** Press `F2` or `F10` during startup
   - **Lenovo:** Press `F1` or `Fn + F2`
   - **ASUS:** Press `F2` or `Delete`
   - **MSI:** Press `Delete`
2. Look for virtualization settings (varies by manufacturer):
   - Intel: "Intel VT-x", "Intel Virtualization Technology", or "Virtualization"
   - AMD: "AMD-V" or "SVM Mode"
3. Enable the option
4. Save changes and exit (usually `F10`)
5. Restart Docker Desktop

#### Issue: "Port 8080 already in use"
**Solution:** Change the port mapping:

**With docker-compose.yml:**
```yaml
services:
  app:
    ports:
      - "8081:8080"  # Use port 8081 on your computer instead
```

**With docker run:**
```bash
# In WSL/bash terminal
docker run -d \
  --name email-signature-app \
  -p 8081:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=3306 \
  -e DB_DATABASE=email_signature_db \
  -e DB_USERNAME=root \
  -e DB_PASSWORD=password \
  could198/email-signature-generator:latest
```

Then open: http://localhost:8081

**Find what's using port 8080:**
```bash
# In WSL terminal
sudo lsof -i :8080
# Or
sudo netstat -tlnp | grep :8080
```

#### Issue: Docker Desktop won't start
**Solutions to try:**

1. **Ensure WSL 2 is running:**
   ```powershell
   # In PowerShell
   wsl --status
   wsl --set-default-version 2
   ```

2. **Check WSL integration in Docker Desktop:**
   - Open Docker Desktop → Settings → Resources → WSL Integration
   - Make sure your distro (Ubuntu) is enabled
   - Click "Apply & Restart"

3. **Restart Docker Desktop:**
   - Click Docker icon in system tray (bottom-right, near clock)
   - Select "Quit Docker Desktop"
   - Wait 10 seconds
   - Start Docker Desktop from Start Menu

4. **Check Windows Services:**
   - Press `Win + R`
   - Type: `services.msc` and press Enter
   - Find "Docker Desktop Service"
   - Right-click → Restart

5. **View Docker logs:**
   - Click Docker icon in system tray
   - Select "Troubleshoot"
   - Click "View logs"
   - Look for WSL-related errors

6. **Reset Docker Desktop (Last Resort):**
   - Open Docker Desktop
   - Click Settings (gear icon)
   - Go to "Troubleshoot"
   - Click "Reset to factory defaults"
   - **Warning:** This deletes all containers, images, and volumes

#### Issue: Container starts but application doesn't load
**Solution:** Check container logs:

```bash
# In WSL terminal (or macOS/Linux terminal)
# View app logs
docker logs email-signature-app

# Or with docker-compose
docker-compose logs app

# Follow logs in real-time
docker logs -f email-signature-app
```

**Common errors in logs:**
- `SQLSTATE[HY000] [2002] Connection refused` → Database not ready, wait 30 seconds
- `SQLSTATE[HY000] [1045] Access denied` → Wrong DB password in docker-compose.yml
- `404 Not Found` → Migrations not run yet, run `docker-compose exec app php artisan migrate`

#### Issue: MySQL container won't start
**Solution:** Port 3306 might be in use:

**Check what's using port 3306:**
```bash
# In WSL terminal
sudo lsof -i :3306
# Or
sudo netstat -tlnp | grep :3306
```

**Solution 1 - Stop local MySQL (if running in WSL):**
```bash
# In WSL terminal
sudo service mysql stop
```

**Solution 2 - Use different port:**
```yaml
# In docker-compose.yml
services:
  mysql:
    ports:
      - "3307:3306"  # Use 3307 on your computer
  app:
    environment:
      DB_PORT: 3306  # Keep this as 3306 (internal port)
```

#### Issue: Changes not reflected in Docker container
**Solution:** Rebuild the container:

```bash
# In WSL terminal (or macOS/Linux terminal)
# Pull latest image
docker pull could198/email-signature-generator:latest

# Stop and remove old container
docker stop email-signature-app
docker rm email-signature-app

# Start new container
docker run -d \
  --name email-signature-app \
  -p 8080:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=3306 \
  -e DB_DATABASE=email_signature_db \
  -e DB_USERNAME=root \
  -e DB_PASSWORD=password \
  could198/email-signature-generator:latest

# Or with docker-compose
docker-compose down
docker-compose pull
docker-compose up -d
```

#### Issue: Can't access application at localhost:8080
**Solutions:**

1. **Check if container is running:**
```bash
# In WSL terminal (or macOS/Linux terminal)
docker ps
```
You should see `email-signature-app` in the list.

2. **Check container logs for errors:**
```bash
docker logs email-signature-app
```

3. **Try 127.0.0.1 instead:**
Open browser and try: http://127.0.0.1:8080

4. **Check Windows Firewall:**
   - Press `Win + R`, type `firewall.cpl`
   - Click "Allow an app through Windows Firewall"
   - Click "Change settings" → "Allow another app"
   - Browse to Docker Desktop and allow it

5. **Restart Docker Desktop:**
Sometimes a simple restart fixes networking issues.

#### Issue: "no matching manifest for linux/amd64" or "no matching manifest for linux/arm64"

**Problem:** The Docker image was built for a different CPU architecture.

**Solution 1 - Use Multi-Platform Image (If you control the Docker Hub repo):**

Rebuild and push with multi-platform support:

```bash
# On your Mac - create builder (first time only)
docker buildx create --name multiplatform --use
docker buildx inspect --bootstrap

# Build for both ARM64 (Mac) and AMD64 (Windows/Intel)
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t could198/email-signature-generator:latest \
  --push \
  .

# Verify both platforms are available
docker buildx imagetools inspect could198/email-signature-generator:latest
```

You should see output showing both architectures:
```
Manifest List: Yes
Platforms:
  linux/amd64
  linux/arm64
```

**Solution 2 - Build Locally (Workaround for students):**

If the Docker Hub image doesn't work, build it locally:

```bash
# In WSL terminal (or macOS/Linux terminal) - clone the repo first
git clone https://github.com/AndorH1/email_generator.git
cd email_generator

# Build for your platform
docker build -t email-signature-generator:latest .

# Update docker-compose.yml to use local image:
# Change:
#   image: could198/email-signature-generator:latest
# To:
#   image: email-signature-generator:latest

# Then start services
docker-compose up -d
```

**Solution 3 - Use Platform Flag (Quick Test):**

```bash
# In WSL terminal - force pull for linux/amd64
docker pull --platform linux/amd64 could198/email-signature-generator:latest
```

### Testing API Endpoints

```bash
# Test registration
curl -X POST http://localhost:8080/api/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123","full_name":"Test User"}'

# Test login
curl -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Test templates (no auth required)
curl http://localhost:8080/api/templates

# Test profile (requires Bearer token)
curl http://localhost:8080/api/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Code Formatting

```bash
# Run Laravel Pint to format code
./vendor/bin/pint
```

### Running Tests

```bash
# Create a test
php artisan make:test AuthTest

# Run all tests
php artisan test

# Run specific test
php artisan test --filter=AuthTest
```

---

## Next Steps

1. **Customize Templates:** Add your own email signature templates
2. **Add Features:** Implement template preview, batch operations, etc.
3. **Deploy:** Use Laravel Forge, AWS, or DigitalOcean
4. **Add Email Integration:** Send signatures via email
5. **Implement File Upload:** Allow users to upload their own avatars

---

## Quick Reference for WSL Users

### Common WSL Commands

```bash
# Open Ubuntu terminal from anywhere
wsl

# Check WSL status
wsl --status

# Shut down WSL (if needed)
wsl --shutdown

# List installed distros
wsl --list --verbose

# Access Windows files from WSL
cd /mnt/c/Users/YourName/Documents

# Access WSL files from Windows Explorer
# Type in address bar: \\wsl$\Ubuntu\home\yourusername
```

### Project Workflow in WSL

```bash
# 1. Navigate to project
cd ~/Projects/email-signature-generator

# 2. Start Docker services
docker-compose up -d

# 3. Check logs
docker-compose logs -f app

# 4. Access MySQL
docker exec -it email-signature-mysql mysql -u root -p

# 5. Stop services when done
docker-compose down
```

### VS Code with WSL

```bash
# Install "Remote - WSL" extension in VS Code
# Then open project from WSL terminal:
cd ~/Projects/email-signature-generator
code .

# VS Code will open with WSL integration
# Your terminal in VS Code will be the WSL terminal
```

### Troubleshooting WSL

**Docker commands not found:**
```bash
# Make sure Docker Desktop is running
# Check WSL integration in Docker Desktop settings
docker --version
```

**Slow file access:**
```bash
# Work in WSL filesystem, not /mnt/c/
# Good: ~/Projects/
# Bad: /mnt/c/Users/YourName/Projects/
```

**Can't access localhost:**
```bash
# Windows can access WSL ports directly
# Just open: http://localhost:8080 in Windows browser
```

---

## Resources

- **Laravel Documentation:** https://laravel.com/docs/12.x
- **Laravel Sanctum:** https://laravel.com/docs/12.x/sanctum
- **Bootstrap 5:** https://getbootstrap.com/docs/5.3
- **MySQL Documentation:** https://dev.mysql.com/doc/
- **WSL Documentation:** https://learn.microsoft.com/en-us/windows/wsl/
- **Docker Desktop WSL 2:** https://docs.docker.com/desktop/wsl/

---

## Support

For issues or questions:
1. Check the Laravel documentation
2. Review the code comments
3. Test API endpoints with curl or Postman
4. Check Laravel logs: `storage/logs/laravel.log`

Good luck with your project! 🚀
