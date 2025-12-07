# Zenith Framework - Complete Installation & Setup Guide

Welcome to the Zenith Framework! This guide covers installation, setup, and quick start for all platforms.

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Installation Methods](#installation-methods)
3. [Quick Start](#quick-start)
4. [Verification](#verification)
5. [Troubleshooting](#troubleshooting)
6. [Next Steps](#next-steps)

---

## System Requirements

### Minimum Requirements
- **OS**: Windows 10+, macOS 10.14+, Linux (Ubuntu 18.04+, CentOS 7+, Debian 9+)
- **Python**: 3.8 or higher
- **Git**: Latest stable version
- **RAM**: 2 GB minimum (4 GB recommended)
- **Disk Space**: 500 MB for installation

### Optional
- Docker: For containerized deployment
- Docker Compose: For multi-service development
- PostgreSQL/MySQL: For database-specific features (SQLite included by default)

---

## Installation Methods

### Method 1: Automated Script (Recommended)

#### macOS / Linux
```bash
# Download and run installer
curl -fsSL https://raw.githubusercontent.com/zenith-lang/zenith/main/install.sh | bash

# Or download first, then run
wget https://raw.githubusercontent.com/zenith-lang/zenith/main/install.sh
chmod +x install.sh
./install.sh
```

#### Windows PowerShell
```powershell
# Run installer with execution policy bypass
powershell -ExecutionPolicy Bypass -File install.ps1

# Or download from Microsoft Store (when available)
# winget install zenith-framework
```

### Method 2: Manual Installation

#### Step 1: Clone Repository
```bash
# Using Git
git clone https://github.com/zenith-lang/zenith.git
cd zenith
```

#### Step 2: Install Compiler
```bash
cd compiler
pip install -e .
cd ..
```

#### Step 3: Install CLI
```bash
cd cli
pip install -e .
cd ..
```

#### Step 4: Verify Installation
```bash
zen --version
```

### Method 3: Using Package Managers

#### macOS (Homebrew)
```bash
brew tap zenith-lang/zenith
brew install zenith
```

#### Linux (apt)
```bash
# Add repository
sudo add-apt-repository ppa:zenith-lang/ppa
sudo apt update

# Install
sudo apt install zenith
```

#### Windows (Chocolatey)
```powershell
choco install zenith
```

### Method 4: Docker

```bash
# Pull Docker image
docker pull zenith-lang/zenith:latest

# Run container
docker run -it zenith-lang/zenith zen --version

# Start interactive shell
docker run -it zenith-lang/zenith bash
```

---

## Quick Start

### 1. Create a New Project

```bash
# Create web application
zen new my_app --template web

# Or create API project
zen new my_api --template api

# Or create simple CLI app
zen new my_cli --template cli
```

### 2. Project Structure
```
my_app/
├── app/                    # Application code
├── config/                 # Configuration
├── database/               # Migrations & seeds
├── public/                 # Web root
├── routes/                 # Route definitions
├── tests/                  # Test files
├── Zen.toml               # Project manifest
└── README.md
```

### 3. Install Dependencies

```bash
cd my_app
zenpkg install
```

### 4. Run Development Server

```bash
# Start development server (http://localhost:8000)
zen serve

# Or specify port
zen serve --port 3000

# Watch for changes and rebuild
zen watch
```

### 5. Create Your First Route

Edit `routes/web.zen`:
```zen
import { HomeController } from "app/Http/Controllers";

Route.get("/", HomeController.index);
Route.get("/hello/:name", fn(name: string) {
    return "Hello, " + name + "!";
});
```

### 6. Create a Controller

```bash
zen make:controller HelloController
```

Edit `app/Http/Controllers/HelloController.zen`:
```zen
class HelloController {
    fn index(): View {
        return view("hello", { message: "Welcome to Zenith!" });
    }
}
```

### 7. Create a View Component

Create `app/Views/hello.zen`:
```zen
page Hello(message: string) {
    layout: "app";
    
    fn render() {
        <div class="container">
            <h1>{this.message}</h1>
            <p>Your Zenith application is running!</p>
        </div>
    }
}
```

### 8. Run Tests

```bash
# Run all tests
zen test

# Run specific test
zen test tests/Feature/HelloTest.zen

# Run with coverage
zen test --coverage
```

---

## Verification

### Check Installation

```bash
# Display version
zen --version

# Show installation info
zen verify

# List available commands
zen help
```

### Run Example Project

```bash
# Clone examples repository
git clone https://github.com/zenith-lang/examples.git
cd examples/hello-world

# Install dependencies
zenpkg install

# Run project
zen serve
```

---

## Troubleshooting

### Python Not Found
```bash
# macOS
brew install python@3.11

# Ubuntu/Debian
sudo apt install python3.11

# Windows
# Download from https://www.python.org/downloads/
```

### Git Not Found
```bash
# macOS
brew install git

# Ubuntu/Debian
sudo apt install git

# Windows
# Download from https://git-scm.com/
```

### Permission Denied (macOS/Linux)
```bash
# Fix permissions
sudo chown -R $USER ~/.zenith

# Or run with sudo
sudo zen serve
```

### Port Already in Use
```bash
# Use different port
zen serve --port 3000

# Or find and kill process using port 8000
lsof -i :8000
kill -9 <PID>
```

### Module Not Found
```bash
# Reinstall dependencies
zen clean
zenpkg install

# Update dependencies
zenpkg update
```

### "zen" Command Not Found
```bash
# Refresh PATH (macOS/Linux)
source ~/.bashrc
# or
source ~/.zshrc

# Windows: Open new terminal window

# Or verify installation location
which zen
```

### Build Fails

```bash
# Clear cache and rebuild
zen clean
zen build --verbose

# Check for syntax errors
zen lint

# Run type checking
zen check
```

---

## Environment Configuration

### Create `.env` File

```bash
# Copy template
cp .env.example .env

# Edit configuration
APP_NAME=MyZenithApp
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=sqlite
# DB_HOST=127.0.0.1
# DB_PORT=5432
# DB_DATABASE=zenith_dev
# DB_USERNAME=zenith
# DB_PASSWORD=secret
```

### Database Setup

```bash
# Run migrations
zen migrate

# Run seeders
zen seed:run

# Rollback migrations
zen migrate:rollback
```

---

## Next Steps

### Learn the Language
- Read [ZenithLanguage.md](./ZenithLanguage.md)
- Explore [code examples](./examples/)
- Watch tutorials (coming soon)

### Build Your App
- Follow [Web Framework guide](./ZenWebFramework.md)
- Review [architecture documentation](./architecture.md)
- Check [best practices guide](./BEST_PRACTICES.md)

### Deploy Your Application
- Read [deployment guide](./DEPLOYMENT.md)
- Set up [CI/CD pipeline](./CI_CD.md)
- Configure [production environment](./PRODUCTION.md)

### Get Help
- **Documentation**: https://zenith-lang.org/docs
- **Community Forum**: https://forum.zenith-lang.org
- **Discord Server**: https://discord.gg/zenith
- **Issue Tracker**: https://github.com/zenith-lang/zenith/issues
- **Email Support**: support@zenith-lang.org

---

## Common Commands Reference

```bash
# Project Management
zen new my_app                  # Create new project
zen serve                       # Start dev server
zen build                       # Build project
zen test                        # Run tests
zen clean                       # Clean build artifacts

# Code Generation
zen make:controller UserController
zen make:model User
zen make:migration create_users_table
zen make:middleware AuthMiddleware
zen make:service UserService
zen make:test UserTest

# Dependencies
zenpkg add package_name         # Add dependency
zenpkg update                   # Update dependencies
zenpkg remove package_name      # Remove dependency
zenpkg list                     # List dependencies

# Database
zen migrate                     # Run migrations
zen migrate:rollback            # Rollback migrations
zen seed:run                    # Run seeders
zen tinker                      # Interactive shell (REPL)

# Development
zen fmt                         # Format code
zen lint                        # Lint code
zen watch                       # Watch for changes
zen debug                       # Start debugger

# Deployment
zen build --release             # Production build
zen deploy                      # Deploy to production
zen rollback                    # Rollback deployment
```

---

## System-Specific Notes

### macOS
- Use Homebrew for package management: `brew install zenith`
- For M1/M2 Macs, ensure Python is installed for ARM64
- May need Xcode Command Line Tools: `xcode-select --install`

### Windows
- Use PowerShell as Administrator for system-wide installation
- Ensure Python is in PATH: `python --version`
- Windows Defender may slow down builds; add exclusion for `%APPDATA%\Zenith`

### Linux
- Ensure development headers are installed: `sudo apt install python3-dev`
- On CentOS/RHEL: Use `yum` instead of `apt`
- May need to install `build-essential`: `sudo apt install build-essential`

---

## Uninstallation

### Remove Zenith

```bash
# macOS (Homebrew)
brew uninstall zenith

# Linux (apt)
sudo apt remove zenith

# Windows (Chocolatey)
choco uninstall zenith

# Manual removal
rm -rf ~/.zenith
rm /usr/local/bin/zen
```

---

## Support

For issues or questions:
1. Check [FAQ](./FAQ.md)
2. Search [GitHub Issues](https://github.com/zenith-lang/zenith/issues)
3. Ask on [Community Forum](https://forum.zenith-lang.org)
4. File a [new issue](https://github.com/zenith-lang/zenith/issues/new)

---

**Happy coding with Zenith!** 🚀


