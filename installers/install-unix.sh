#!/bin/bash
# Zenith Language Framework - Unix/Linux/macOS Installer
# Installs Zenith compiler and sets up PATH for Unix-like systems

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
INSTALL_PATH="${INSTALL_PATH:-/usr/local/zenith}"
ADD_TO_PATH="${ADD_TO_PATH:-true}"
VERIFY="${VERIFY:-true}"
SKIP_BUILD="${SKIP_BUILD:-false}"

# Detect OS
OS_TYPE=$(uname -s)
DISTRO=""
if [ "$OS_TYPE" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    fi
fi

print_header() {
    echo -e "\n${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        print_warning "This installer should be run with sudo for system-wide installation"
        print_warning "Running with user-only installation to $HOME/.local/zenith"
        INSTALL_PATH="$HOME/.local/zenith"
        return 1
    fi
    return 0
}

find_source() {
    # Look for zenith-compiler in parent directories
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local possible_paths=(
        "$script_dir/../zenith-compiler"
        "$script_dir/.."
        "$HOME/zenith-compiler"
        "$HOME/Desktop/zenith-compiler"
        "/opt/zenith-compiler"
    )
    
    for path in "${possible_paths[@]}"; do
        if [ -f "$path/src/main.zen" ]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

build_zenith() {
    local source_path="$1"
    
    echo -e "\n${CYAN}Building Zenith from source...${NC}"
    
    local bootstrap_script="$source_path/bootstrap.sh"
    if [ ! -f "$bootstrap_script" ]; then
        print_error "Bootstrap script not found at: $bootstrap_script"
        return 1
    fi
    
    cd "$source_path"
    if bash "$bootstrap_script" --build; then
        print_success "Zenith build completed"
        return 0
    else
        print_error "Build failed"
        return 1
    fi
}

create_install_dir() {
    local path="$1"
    
    echo -e "\n${CYAN}Creating installation directory...${NC}"
    
    if mkdir -p "$path"; then
        print_success "Created directory: $path"
        return 0
    else
        print_error "Failed to create directory: $path"
        return 1
    fi
}

copy_zenith_binary() {
    local source_path="$1"
    local target_path="$2"
    
    echo -e "\n${CYAN}Copying Zenith binaries...${NC}"
    
    # Copy main executable
    if [ ! -f "$source_path/bin/zen" ]; then
        print_error "Zenith executable not found at: $source_path/bin/zen"
        return 1
    fi
    
    cp "$source_path/bin/zen" "$target_path/zen"
    chmod +x "$target_path/zen"
    print_success "Copied zen executable to $target_path"
    
    # Copy library files
    if [ -d "$source_path/src" ]; then
        mkdir -p "$target_path/lib"
        cp -r "$source_path/src"/* "$target_path/lib/"
        print_success "Copied library files to $target_path/lib"
    fi
    
    return 0
}

add_to_path() {
    local path="$1"
    local shell_rc=""
    
    echo -e "\n${CYAN}Updating shell configuration...${NC}"
    
    # Detect shell
    if [ -n "$BASH_VERSION" ]; then
        shell_rc="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        shell_rc="$HOME/.zshrc"
    else
        shell_rc="$HOME/.profile"
    fi
    
    # Check if path is already there
    if grep -q "$path" "$shell_rc" 2>/dev/null; then
        print_warning "Path already in $shell_rc"
        return 0
    fi
    
    # Add to shell config
    {
        echo ""
        echo "# Zenith Language Framework"
        echo "export PATH=\"$path:\$PATH\""
    } >> "$shell_rc"
    
    print_success "Added $path to $shell_rc"
    print_warning "Please run: source $shell_rc (or restart your terminal)"
    
    # Update current session
    export PATH="$path:$PATH"
    
    return 0
}

add_symlink() {
    local path="$1"
    
    echo -e "\n${CYAN}Creating symlink in /usr/local/bin...${NC}"
    
    if [ ! -d "/usr/local/bin" ]; then
        mkdir -p /usr/local/bin
    fi
    
    ln -sf "$path/zen" /usr/local/bin/zen
    print_success "Created symlink: /usr/local/bin/zen"
    
    return 0
}

verify_installation() {
    local path="$1"
    
    print_header "Verifying Installation"
    
    # Check if executable exists
    if [ ! -f "$path/zen" ]; then
        print_error "zen executable not found in installation directory"
        return 1
    fi
    print_success "zen executable found"
    
    # Try to run zen --version
    if command -v "$path/zen" >/dev/null 2>&1; then
        local version_output
        version_output=$("$path/zen" --version 2>/dev/null || true)
        if [ -n "$version_output" ]; then
            print_success "zen --version: $version_output"
        fi
    else
        print_warning "Could not execute zen"
    fi
    
    # Check if in PATH
    if command -v zen >/dev/null 2>&1; then
        print_success "zen command available in PATH"
    else
        print_warning "zen not in current PATH (will be available after shell restart)"
    fi
    
    return 0
}

create_uninstall_script() {
    local path="$1"
    
    cat > "$path/uninstall.sh" << 'EOF'
#!/bin/bash
# Zenith Language Framework - Uninstaller

INSTALL_PATH="$1"

echo "Zenith Language Framework Uninstaller"
echo "======================================"
echo ""

# Remove symlink
if [ -L /usr/local/bin/zen ]; then
    rm /usr/local/bin/zen
    echo "✓ Removed symlink from /usr/local/bin"
fi

# Remove installation directory
if [ -d "$INSTALL_PATH" ]; then
    rm -rf "$INSTALL_PATH"
    echo "✓ Removed installation directory"
fi

# Remove from shell configs
for rc in ~/.bashrc ~/.zshrc ~/.profile; do
    if [ -f "$rc" ]; then
        sed -i.bak '/# Zenith Language Framework/d' "$rc"
        sed -i.bak '/export PATH.*Zenith/d' "$rc"
    fi
done
echo "✓ Removed from shell configurations"

echo ""
echo "✓ Zenith Language Framework uninstalled successfully"
EOF
    
    chmod +x "$path/uninstall.sh"
    print_success "Created uninstall script at: $path/uninstall.sh"
}

# Main installation flow
print_header "Zenith Language Framework - Unix/Linux/macOS Installer"

echo "OS: $OS_TYPE"
[ -n "$DISTRO" ] && echo "Distro: $DISTRO"
echo ""

# Check sudo/permissions
check_sudo

# Find source
echo -e "${CYAN}Searching for Zenith source files...${NC}"
SOURCE_DIR=$(find_source)
if [ -z "$SOURCE_DIR" ]; then
    print_error "Could not find Zenith source directory"
    echo "Please run this installer from the zenith-framework directory"
    exit 1
fi
print_success "Found Zenith source at: $SOURCE_DIR"

# Build Zenith (unless skipped)
if [ "$SKIP_BUILD" = "false" ]; then
    if ! build_zenith "$SOURCE_DIR"; then
        exit 1
    fi
fi

# Create install directory
if ! create_install_dir "$INSTALL_PATH"; then
    exit 1
fi

# Copy binaries
if ! copy_zenith_binary "$SOURCE_DIR" "$INSTALL_PATH"; then
    exit 1
fi

# Add to PATH
if [ "$ADD_TO_PATH" = "true" ]; then
    if ! add_to_path "$INSTALL_PATH"; then
        print_warning "Could not update PATH automatically"
    fi
fi

# Create symlink (if running as root)
if [ "$EUID" -eq 0 ]; then
    if ! add_symlink "$INSTALL_PATH"; then
        print_warning "Could not create symlink"
    fi
fi

# Create uninstall script
create_uninstall_script "$INSTALL_PATH"

# Verify installation
if [ "$VERIFY" = "true" ]; then
    verify_installation "$INSTALL_PATH"
fi

print_header "Installation Complete!"
echo -e "${GREEN}✓ Zenith Language Framework installed successfully${NC}"
echo ""
echo -e "${CYAN}Install Location: $INSTALL_PATH${NC}"
echo -e "${CYAN}Documentation: https://github.com/zenithframework/zenlang/wiki${NC}"
echo ""
echo -e "${YELLOW}To complete setup:${NC}"
echo "  1. Update your PATH: source ~/.bashrc (or ~/.zshrc, ~/.profile)"
echo "  2. Or restart your terminal"
echo ""
echo -e "${CYAN}Getting started:${NC}"
echo "  zen --help          Show command help"
echo "  zen --version       Show version information"
echo "  zen compile file.zen  Compile a Zen program"
echo "  zen execute file.zen  Run a Zen program"
echo ""
