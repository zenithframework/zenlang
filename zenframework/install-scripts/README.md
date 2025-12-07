# Zenith Language Framework - Installation Guide

This directory contains cross-platform installation scripts for the Zenith Language Framework.

## Quick Install

### Windows (PowerShell)
```powershell
# Run as Administrator
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\install-windows.ps1
```

### Linux/macOS (Bash)
```bash
chmod +x install-unix.sh
sudo ./install-unix.sh
# Or without sudo (user-only installation):
./install-unix.sh
```

## Installation Options

### Windows Installer (`install-windows.ps1`)

**Features:**
- Automatic admin privilege detection
- Builds Zenith from source
- Adds to system PATH
- Creates Start Menu shortcuts
- Creates Windows Registry uninstall entry
- Full verification after installation
- Uninstall support

**Parameters:**
```powershell
.\install-windows.ps1 `
    -InstallPath "C:\Program Files\Zenith" `
    -AddToPath $true `
    -CreateShortcuts $true `
    -Verify $true `
    -NoAdmin $false
```

**Post-Installation:**
- Restart your terminal for PATH changes to take effect
- Use `zen --help` to get started

---

### Unix/Linux/macOS Installer (`install-unix.sh`)

**Features:**
- Automatic OS detection (Linux, macOS)
- Builds Zenith from source
- Updates shell configuration (.bashrc, .zshrc, .profile)
- Creates symlink in /usr/local/bin
- Full verification after installation
- Uninstall support

**Environment Variables:**
```bash
INSTALL_PATH=/usr/local/zenith     # Installation directory
ADD_TO_PATH=true                   # Add to PATH
VERIFY=true                        # Verify after install
SKIP_BUILD=false                   # Skip building from source
```

**Examples:**
```bash
# System-wide installation (requires sudo)
sudo INSTALL_PATH=/opt/zenith ./install-unix.sh

# User-only installation (no sudo required)
./install-unix.sh

# Skip build if already built
SKIP_BUILD=true ./install-unix.sh
```

**Post-Installation:**
- Restart your terminal or run: `source ~/.bashrc` (or ~/.zshrc)
- Use `zen --help` to get started

---

## Manual Installation

If you prefer manual installation:

### Windows (Manual)

1. **Build Zenith:**
   ```powershell
   cd compiler
   .\bootstrap.ps1 -Build
   ```

2. **Create Installation Directory:**
   ```powershell
   mkdir "C:\Program Files\Zenith"
   ```

3. **Copy Files:**
   ```powershell
   Copy-Item "bin\zen.bat" "C:\Program Files\Zenith\"
   Copy-Item "src\*" "C:\Program Files\Zenith\lib\" -Recurse
   ```

4. **Add to PATH:**
   - Open System Properties → Environment Variables
   - Add `C:\Program Files\Zenith` to PATH
   - Restart terminal

---

### Linux/macOS (Manual)

1. **Build Zenith:**
   ```bash
   cd compiler
   chmod +x bootstrap.sh
   ./bootstrap.sh --build
   ```

2. **Create Installation Directory:**
   ```bash
   sudo mkdir -p /usr/local/zenith
   sudo chown $USER:$USER /usr/local/zenith
   ```

3. **Copy Files:**
   ```bash
   cp bin/zen /usr/local/zenith/
   cp -r src/* /usr/local/zenith/lib/
   chmod +x /usr/local/zenith/zen
   ```

4. **Create Symlink:**
   ```bash
   sudo ln -s /usr/local/zenith/zen /usr/local/bin/zen
   ```

5. **Update PATH (if needed):**
   ```bash
   echo 'export PATH="/usr/local/zenith:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

---

## Uninstallation

### Windows
1. Go to **Control Panel** → **Programs** → **Programs and Features**
2. Find "Zenith Language Framework" and click **Uninstall**

Or use PowerShell:
```powershell
& "C:\Program Files\Zenith\uninstall.ps1"
```

### Linux/macOS
```bash
/usr/local/zenith/uninstall.sh /usr/local/zenith
```

Or remove manually:
```bash
rm -rf /usr/local/zenith
rm /usr/local/bin/zen
# Remove from ~/.bashrc or ~/.zshrc
```

---

## Verification

After installation, verify the setup:

```bash
# Check version
zen --version

# Show help
zen --help

# Compile a file
zen compile examples/hello.zen

# Execute a file
zen execute examples/hello.zen
```

---

## Troubleshooting

### Command not found after installation

**Windows:**
- Close and reopen PowerShell or Command Prompt
- Verify path: `$env:PATH`

**Linux/macOS:**
- Run: `source ~/.bashrc` (or `~/.zshrc`)
- Or restart terminal
- Check: `echo $PATH`

### Build fails during installation

1. Ensure you have the latest version of the repository
2. Check that `bootstrap.ps1` or `bootstrap.sh` is executable
3. Verify you have the required build tools

**Windows:**
- Requires PowerShell 5.0+
- .NET Framework 4.5+ (for some operations)

**Linux/macOS:**
- Requires Bash 4.0+
- Check: `bash --version`

### Permission denied

**Linux/macOS:**
```bash
chmod +x install-unix.sh
chmod +x bootstrap.sh
```

### Symlink issues (Linux/macOS)

If the symlink creation fails:
```bash
# Remove old symlink
sudo rm /usr/local/bin/zen

# Create new one
sudo ln -s /usr/local/zenith/zen /usr/local/bin/zen
```

---

## Platform-Specific Notes

### Windows

- Installation to Program Files requires Administrator privileges
- User-only installation available without Admin (stores in %LOCALAPPDATA%)
- Start Menu shortcuts created automatically
- Registry entry for Add/Remove Programs created
- Requires PowerShell 5.0 or higher

### Linux

Tested on:
- Ubuntu 20.04+
- Debian 11+
- CentOS 8+
- Fedora 35+

Installation paths:
- **System-wide:** `/usr/local/zenith` (with sudo)
- **User-only:** `~/.local/zenith` (without sudo)

### macOS

Tested on:
- macOS 10.15+
- M1/M2 native support
- Intel x86-64 support

Installation paths:
- **System-wide:** `/usr/local/zenith` (with sudo)
- **User-only:** `~/.local/zenith` (without sudo)

---

## Getting Help

- **Documentation:** https://github.com/zenithframework/zenlang/wiki
- **Issues:** https://github.com/zenithframework/zenlang/issues
- **Discussions:** https://github.com/zenithframework/zenlang/discussions

---

## Support Matrix

| Platform | Status | Installation | Build | Run |
|----------|--------|--------------|-------|-----|
| Windows 10+ | ✅ Supported | PowerShell | .NET/PowerShell | Direct/Batch |
| Ubuntu 20.04+ | ✅ Supported | Bash | Bash | Bash |
| macOS 10.15+ (Intel) | ✅ Supported | Bash | Bash | Bash |
| macOS 12+ (M1/M2) | ✅ Supported | Bash | Bash | Bash |
| Debian 11+ | ✅ Supported | Bash | Bash | Bash |
| CentOS 8+ | ✅ Supported | Bash | Bash | Bash |
| Fedora 35+ | ✅ Supported | Bash | Bash | Bash |

---

## License

The Zenith Language Framework is released under the MIT License. See LICENSE file for details.

