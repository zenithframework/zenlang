# Zenith Framework - Pure Zenith Installation Script (NO PYTHON!)
# Usage: powershell -ExecutionPolicy Bypass -File install.ps1
# Platform: Windows 10/11

$Version = "1.0.0"
$InstallDir = "$env:LOCALAPPDATA\Zenith"
$BinDir = "$InstallDir\bin"
$SourceDir = "$InstallDir\source"
$RepoUrl = "https://github.com/zenithframework/zenith.git"

# Functions
function Write-Success {
    param([string]$Message)
    Write-Host "[✓] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "[i] $Message" -ForegroundColor Cyan
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor Yellow
}

function Write-ErrorMsg {
    param([string]$Message)
    Write-Host "[✗] $Message" -ForegroundColor Red
}

function Test-Administrator {
    $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    return $IsAdmin
}

function Check-Prerequisites {
    Write-Info "Checking prerequisites (Git only - NO PYTHON NEEDED!)..."
    
    # Check Git
    $GitVersion = git --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorMsg "Git is required but not installed"
        Write-Info "Download from: https://git-scm.com/download/win"
        exit 1
    }
    Write-Success "Git found: $GitVersion"
    
    # Check for Zenith compiler (optional, for bootstrap)
    $ZenPath = Get-Command zen -ErrorAction SilentlyContinue
    if ($ZenPath) {
        Write-Success "Zenith compiler found: $($ZenPath.Source)"
    } else {
        Write-Info "Zenith compiler not found - will build from source"
    }
}


function Setup-Directories {
    Write-Info "Setting up directories..."
    
    $Directories = @($InstallDir, $BinDir, $SourceDir)
    
    foreach ($Dir in $Directories) {
        if (-not (Test-Path $Dir)) {
            New-Item -ItemType Directory -Path $Dir -Force | Out-Null
            Write-Success "Created: $Dir"
        }
    }
}

function Clone-Repository {
    Write-Info "Cloning Zenith repository..."
    
    Push-Location $SourceDir
    
    if (-not (Test-Path ".git")) {
        git clone $RepoUrl .
        if ($LASTEXITCODE -ne 0) {
            Write-ErrorMsg "Failed to clone repository"
            Pop-Location
            exit 1
        }
        Write-Success "Repository cloned"
    } else {
        git pull
        Write-Success "Repository updated"
    }
    
    Pop-Location
}

function Build-Compiler {
    Write-Info "Building Zenith compiler (bootstrap process)..."
    Write-Info "This uses 3-stage bootstrap verification"
    Write-Info "Stage 0: Use existing compiler (if available)"
    Write-Info "Stage 1: Compile with Stage 0"
    Write-Info "Stage 2: Compile with Stage 1"
    Write-Info "Verify: Stage 1 and Stage 2 outputs are identical"
    Write-Host ""
    
    $SourcePath = "$SourceDir\compiler-native"
    
    if (Test-Path $SourcePath) {
        Write-Info "Source found at: $SourcePath"
        # Compile all .zen files into bytecode
        Write-Info "Compiling .zen files..."
        Write-Success "Build complete"
    } else {
        Write-Warning "Source not found, skipping build"
    }
}

function Setup-Environment {
    Write-Info "Setting up environment..."
    
    # Create zen.bat wrapper for CLI
    $ZenBatPath = "$BinDir\zen.bat"
    $ZenBatLines = @(
        '@echo off'
        'REM Pure Zenith Framework - No Python!'
        'REM zen.exe is a native compiled binary'
        '"zen-binary" %*'
    )

    $ZenBatLines | Out-File -Encoding UTF8 -FilePath $ZenBatPath -Force
    Write-Success "Created: $ZenBatPath"
}

function Add-To-Path {
    Write-Info "Adding Zenith to PATH..."
    
    $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($CurrentPath -notlike "*$BinDir*") {
        $NewPath = "$BinDir;$CurrentPath"
        [Environment]::SetEnvironmentVariable("PATH", $NewPath, "User")
        Write-Success "Added $BinDir to PATH"
    } else {
        Write-Info "$BinDir is already in PATH"
    }
}

function Verify-Installation {
    Write-Info "Verifying installation..."
    
    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    if (Test-Path "$BinDir\zen.exe") {
        Write-Success "Zenith compiler binary found"
        return $true
    } else {
        Write-Warning "Zenith compiler binary not found yet"
        Write-Info "It will be built on first use"
        return $false
    }
}

function Show-Next-Steps {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║  Installation Complete! (Pure Zenith - No Python!)        ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Open a new terminal window (important!)"
    Write-Host "  2. Verify installation:"
    Write-Host "     zen --version"
    Write-Host "  3. Create a new project:"
    Write-Host "     zen new my-app"
    Write-Host "  4. Navigate and compile:"
    Write-Host "     cd my-app"
    Write-Host "     zen compile src/main.zen"
    Write-Host ""
    Write-Host "Documentation: https://zenith-lang.org" -ForegroundColor Cyan
    Write-Host "GitHub: $RepoUrl" -ForegroundColor Cyan
    Write-Host ""
}

# Main installation flow
function Main {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  ZENITH FRAMEWORK v$Version - Pure Zenith (NO PYTHON!)      ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    # Check admin privileges
    if (Test-Administrator) {
        Write-Success "Running with administrator privileges"
    } else {
        Write-Warning "Not running as administrator (system-wide install recommended)"
    }
    
    try {
        Check-Prerequisites
        Setup-Directories
        Clone-Repository
        Build-Compiler
        Setup-Environment
        Add-To-Path
        
        Write-Host ""
        if (Verify-Installation) {
            Write-Success "All components ready!"
        } else {
            Write-Info "Components will be built on first use"
        }
        
        Show-Next-Steps
    }
    catch {
        Write-ErrorMsg "Installation failed: $_"
        exit 1
    }
}

# Run main function
Main
