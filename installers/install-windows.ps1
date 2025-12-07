# Zenith Language Framework - Windows Installer
# Installs Zenith compiler and sets up PATH for Windows systems
# Requires PowerShell 5.0+ and Administrator privileges

param(
    [switch]$NoAdmin = $false,
    [string]$InstallPath = "C:\Program Files\Zenith",
    [switch]$AddToPath = $true,
    [switch]$CreateShortcuts = $true,
    [switch]$Verify = $true
)

function Write-Header {
    param([string]$Message)
    Write-Host "`n" -NoNewline
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "=" * 60 -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Test-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-ScriptLocation {
    # Get the directory where this script is located
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    if (-not $scriptPath) {
        $scriptPath = Get-Location
    }
    return $scriptPath
}

function Find-ZenithSource {
    # Look for zenith-compiler in parent directory structure
    $currentPath = Get-ScriptLocation
    $searchPaths = @(
        (Join-Path $currentPath "..\zenith-compiler"),
        (Join-Path $currentPath "..\.."),
        "C:\Projects\zenith-compiler",
        "C:\Users\$env:USERNAME\Desktop\zenith-compiler"
    )
    
    foreach ($path in $searchPaths) {
        if (Test-Path (Join-Path $path "src\main.zen")) {
            return $path
        }
    }
    return $null
}

function Build-Zenith {
    param([string]$SourcePath)
    
    Write-Host "`nBuilding Zenith from source..." -ForegroundColor Cyan
    
    $bootstrapScript = Join-Path $SourcePath "bootstrap.ps1"
    if (-not (Test-Path $bootstrapScript)) {
        Write-Error-Custom "Bootstrap script not found at: $bootstrapScript"
        return $false
    }
    
    try {
        & $bootstrapScript -Build
        Write-Success "Zenith build completed"
        return $true
    }
    catch {
        Write-Error-Custom "Build failed: $_"
        return $false
    }
}

function Create-InstallDirectory {
    param([string]$Path)
    
    Write-Host "`nCreating installation directory..." -ForegroundColor Cyan
    
    try {
        if (-not (Test-Path $Path)) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
            Write-Success "Created directory: $Path"
        }
        else {
            Write-Warning-Custom "Directory already exists: $Path"
        }
        return $true
    }
    catch {
        Write-Error-Custom "Failed to create directory: $_"
        return $false
    }
}

function Copy-ZenithBinary {
    param([string]$SourcePath, [string]$TargetPath)
    
    Write-Host "`nCopying Zenith binaries..." -ForegroundColor Cyan
    
    $sourceFile = Join-Path $SourcePath "bin\zen.bat"
    if (-not (Test-Path $sourceFile)) {
        Write-Error-Custom "Zenith executable not found at: $sourceFile"
        return $false
    }
    
    try {
        Copy-Item $sourceFile (Join-Path $TargetPath "zen.bat") -Force
        Write-Success "Copied zen.bat to $TargetPath"
        
        # Copy supporting files
        $srcDir = Join-Path $SourcePath "src"
        if (Test-Path $srcDir) {
            Copy-Item "$srcDir\*" (Join-Path $TargetPath "lib") -Recurse -Force
            Write-Success "Copied library files to $TargetPath\lib"
        }
        
        return $true
    }
    catch {
        Write-Error-Custom "Failed to copy binaries: $_"
        return $false
    }
}

function Add-ToSystemPath {
    param([string]$Path)
    
    Write-Host "`nUpdating system PATH..." -ForegroundColor Cyan
    
    # Check if path is already in PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    if ($currentPath -like "*$Path*") {
        Write-Warning-Custom "Path already in system PATH"
        return $true
    }
    
    try {
        $newPath = "$currentPath;$Path"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
        
        # Update current session
        $env:PATH = $newPath
        
        Write-Success "Added $Path to system PATH"
        Write-Warning-Custom "Restart any open terminals for PATH changes to take effect"
        
        return $true
    }
    catch {
        Write-Error-Custom "Failed to update PATH: $_"
        return $false
    }
}

function Add-ToUserPath {
    param([string]$Path)
    
    $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($userPath -like "*$Path*") {
        Write-Warning-Custom "Path already in user PATH"
        return $true
    }
    
    try {
        $newPath = if ($userPath) { "$userPath;$Path" } else { $Path }
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        $env:PATH += ";$Path"
        
        Write-Success "Added $Path to user PATH"
        return $true
    }
    catch {
        Write-Error-Custom "Failed to update user PATH: $_"
        return $false
    }
}

function Create-StartMenuShortcut {
    param([string]$Path)
    
    Write-Host "`nCreating Start Menu shortcut..." -ForegroundColor Cyan
    
    try {
        $startMenuPath = [Environment]::GetFolderPath("StartMenu")
        $programsPath = Join-Path $startMenuPath "Programs"
        $zenithFolder = Join-Path $programsPath "Zenith"
        
        if (-not (Test-Path $zenithFolder)) {
            New-Item -ItemType Directory -Path $zenithFolder -Force | Out-Null
        }
        
        $shortcutPath = Join-Path $zenithFolder "Zenith Language.lnk"
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = Join-Path $Path "zen.bat"
        $shortcut.Description = "Zenith Language Framework"
        $shortcut.IconLocation = Join-Path $Path "zen.ico"
        $shortcut.Save()
        
        Write-Success "Created Start Menu shortcut"
        return $true
    }
    catch {
        Write-Warning-Custom "Could not create Start Menu shortcut: $_"
        return $false
    }
}

function Create-UninstallEntry {
    param([string]$Path)
    
    Write-Host "`nCreating uninstall entry..." -ForegroundColor Cyan
    
    try {
        $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Zenith"
        
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        
        New-ItemProperty -Path $regPath -Name "DisplayName" -Value "Zenith Language Framework v1.0.0" -Force | Out-Null
        New-ItemProperty -Path $regPath -Name "DisplayVersion" -Value "1.0.0" -Force | Out-Null
        New-ItemProperty -Path $regPath -Name "InstallLocation" -Value $Path -Force | Out-Null
        New-ItemProperty -Path $regPath -Name "UninstallString" -Value "powershell -ExecutionPolicy Bypass -File `"$Path\uninstall.ps1`"" -Force | Out-Null
        New-ItemProperty -Path $regPath -Name "Publisher" -Value "Zenith Framework" -Force | Out-Null
        New-ItemProperty -Path $regPath -Name "URLInfoAbout" -Value "https://github.com/zenithframework/zenlang" -Force | Out-Null
        
        Write-Success "Created Windows Registry uninstall entry"
        return $true
    }
    catch {
        Write-Warning-Custom "Could not create uninstall entry: $_"
        return $false
    }
}

function Verify-Installation {
    param([string]$Path)
    
    Write-Header "Verifying Installation"
    
    # Check if zen.bat exists
    $zenPath = Join-Path $Path "zen.bat"
    if (-not (Test-Path $zenPath)) {
        Write-Error-Custom "zen.bat not found in installation directory"
        return $false
    }
    Write-Success "zen.bat found"
    
    # Try to run zen --version
    try {
        $output = & $zenPath --version 2>$null
        if ($output -match "Zenith" -or $output -match "version") {
            Write-Success "zen --version executed successfully: $output"
        }
        else {
            Write-Warning-Custom "zen --version returned unexpected output"
        }
    }
    catch {
        Write-Warning-Custom "Could not verify zen executable: $_"
    }
    
    # Check PATH
    if ($env:PATH -like "*$Path*") {
        Write-Success "Installation path found in system PATH"
    }
    else {
        Write-Warning-Custom "Installation path not in current session PATH (will be available after terminal restart)"
    }
    
    return $true
}

function Create-UninstallScript {
    param([string]$Path)
    
    $uninstallScript = @"
# Zenith Language Framework - Windows Uninstaller

`$InstallPath = `"$Path`"

Write-Host "Zenith Language Framework Uninstaller" -ForegroundColor Cyan
Write-Host "=========================================`n"

# Remove from PATH
`$currentPath = [Environment]::GetEnvironmentVariable(`"PATH`", `"Machine`")
if (`$currentPath -like `"*`$InstallPath*`") {
    `$newPath = `$currentPath -replace [regex]::Escape(`$InstallPath + `;`"), ``
    [Environment]::SetEnvironmentVariable(`"PATH`", `$newPath, `"Machine`")
    Write-Host "✓ Removed from system PATH"
}

# Remove directory
if (Test-Path `$InstallPath) {
    Remove-Item `$InstallPath -Recurse -Force
    Write-Host "✓ Removed installation directory"
}

# Remove Start Menu shortcut
`$startMenuPath = [Environment]::GetFolderPath(`"StartMenu`")
`$zenithFolder = Join-Path `$startMenuPath `"Programs\Zenith`"
if (Test-Path `$zenithFolder) {
    Remove-Item `$zenithFolder -Recurse -Force
    Write-Host "✓ Removed Start Menu shortcut"
}

# Remove registry entry
Remove-Item `"HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Zenith`" -Force -ErrorAction SilentlyContinue
Write-Host "✓ Removed registry entry"

Write-Host "`n✓ Zenith Language Framework uninstalled successfully"
"@
    
    $uninstallPath = Join-Path $Path "uninstall.ps1"
    Set-Content -Path $uninstallPath -Value $uninstallScript -Force
    Write-Success "Created uninstall script at: $uninstallPath"
}

# Main installation flow
Write-Header "Zenith Language Framework - Windows Installer"

# Check admin privileges
if (-not (Test-AdminPrivileges)) {
    if (-not $NoAdmin) {
        Write-Warning-Custom "Administrator privileges required for system-wide installation"
        Write-Host "Attempting to elevate privileges..."
        
        $arguments = "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -NoAdmin"
        Start-Process -FilePath PowerShell.exe -ArgumentList $arguments -Verb RunAs
        exit
    }
    else {
        Write-Warning-Custom "Running without admin privileges - using user PATH only"
        $AddToPath = $true
        $InstallPath = Join-Path $env:LOCALAPPDATA "Zenith"
    }
}

# Find source
Write-Host "`nSearching for Zenith source files..." -ForegroundColor Cyan
$sourceDir = Find-ZenithSource
if (-not $sourceDir) {
    Write-Error-Custom "Could not find Zenith source directory"
    Write-Host "Please run this installer from the zenith-framework directory or specify -SourcePath"
    exit 1
}
Write-Success "Found Zenith source at: $sourceDir"

# Build Zenith
if (-not (Build-Zenith $sourceDir)) {
    exit 1
}

# Create install directory
if (-not (Create-InstallDirectory $InstallPath)) {
    exit 1
}

# Copy binaries
if (-not (Copy-ZenithBinary $sourceDir $InstallPath)) {
    exit 1
}

# Add to PATH
if ($AddToPath) {
    if (Test-AdminPrivileges) {
        Add-ToSystemPath $InstallPath
    }
    else {
        Add-ToUserPath $InstallPath
    }
}

# Create shortcuts
if ($CreateShortcuts -and (Test-AdminPrivileges)) {
    Create-StartMenuShortcut $InstallPath
    Create-UninstallEntry $InstallPath
    Create-UninstallScript $InstallPath
}

# Verify installation
if ($Verify) {
    Verify-Installation $InstallPath
}

Write-Header "Installation Complete!"
Write-Host "✓ Zenith Language Framework installed successfully" -ForegroundColor Green
Write-Host "`nInstall Location: $InstallPath" -ForegroundColor Cyan
Write-Host "Documentation: https://github.com/zenithframework/zenlang/wiki" -ForegroundColor Cyan

if ($AddToPath) {
    Write-Warning-Custom "Please restart your terminal for PATH changes to take effect"
}

Write-Host "`nGetting started:" -ForegroundColor Cyan
Write-Host "  zen --help          Show command help"
Write-Host "  zen --version       Show version information"
Write-Host "  zen compile file.zen  Compile a Zen program"
Write-Host "  zen execute file.zen  Run a Zen program"
Write-Host ""
