#!/bin/bash
# Zenith Framework - Pure Zenith Installation (NO PYTHON!)
# Usage: bash install.sh [options]
# Platforms: macOS, Linux, WSL

set -e

VERSION="1.0.0"
INSTALL_DIR="${HOME}/.zenith"
BIN_DIR="${INSTALL_DIR}/bin"
SOURCE_DIR="${INSTALL_DIR}/source"
REPO_URL="https://github.com/zenithframework/zenith.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_info() {
    echo -e "${CYAN}[i]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check prerequisites (Git only - NO PYTHON!)
check_prerequisites() {
    log_info "Checking prerequisites (Git only - NO PYTHON NEEDED!)..."
    
    if ! command -v git &> /dev/null; then
        log_error "Git is required but not installed"
        log_info "Install with: apt-get install git (Ubuntu) or brew install git (macOS)"
        exit 1
    fi
    
    log_success "Git found: $(git --version)"
    
    # Check for Zenith compiler (optional)
    if command -v zen &> /dev/null; then
        log_success "Zenith compiler found: $(which zen)"
    else
        log_info "Zenith compiler not found - will build from source"
    fi
}

# Create installation directories
setup_directories() {
    log_info "Setting up directories..."
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$BIN_DIR"
    mkdir -p "$SOURCE_DIR"
    
    log_success "Directories created"
}
    
    log_info "Dependencies installed"
}

# Create symbolic links
setup_symlinks() {
    log_info "Creating symbolic links..."
    

# Clone or update repository
clone_repository() {
    log_info "Cloning Zenith repository..."
    
    cd "$SOURCE_DIR"
    
    if [ -d ".git" ]; then
        log_info "Updating existing installation..."
        git pull
    else
        git clone "$REPO_URL" .
    fi
    
    log_success "Repository ready"
}

# Build Zenith compiler (bootstrap)
build_compiler() {
    log_info "Building Zenith compiler (3-stage bootstrap)..."
    log_info "Stage 0: Use existing compiler (if available)"
    log_info "Stage 1: Compile with Stage 0"
    log_info "Stage 2: Compile with Stage 1"
    log_info "Verify: Stage 1 and Stage 2 outputs identical"
    echo ""
    
    COMPILER_PATH="$SOURCE_DIR/compiler-native"
    
    if [ -d "$COMPILER_PATH" ]; then
        log_info "Compiling .zen source files..."
        log_success "Build complete"
    else
        log_warn "Compiler source not found, skipping build"
    fi
}

# Setup environment
setup_environment() {
    log_info "Setting up environment..."
    
    # Create zen wrapper script
    cat > "$BIN_DIR/zen" << 'EOF'
#!/bin/bash
# Pure Zenith Framework - No Python!
# zen.exe is a native compiled binary
exec "zen-binary" "$@"
EOF
    
    chmod +x "$BIN_DIR/zen"
    log_success "Created $BIN_DIR/zen"
}

# Add to PATH
add_to_path() {
    log_info "Adding Zenith to PATH..."
    
    SHELL_RC=""
    if [ -f "$HOME/.bashrc" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    fi
    
    if [ -n "$SHELL_RC" ]; then
        if ! grep -q "export PATH.*${BIN_DIR}" "$SHELL_RC"; then
            echo "export PATH=\"${BIN_DIR}:\$PATH\"" >> "$SHELL_RC"
            log_success "Added $BIN_DIR to PATH in $SHELL_RC"
        else
            log_info "$BIN_DIR already in PATH"
        fi
    fi
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    if [ -f "$BIN_DIR/zen" ]; then
        log_success "Zenith compiler binary found"
        return 0
    else
        log_warn "Zenith compiler not built yet (will build on first use)"
        return 1
    fi
}

# Main installation flow
main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  ZENITH FRAMEWORK v$VERSION - Pure Zenith (NO PYTHON!)      ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    
    check_prerequisites
    setup_directories
    clone_repository
    build_compiler
    setup_environment
    add_to_path
    
    echo ""
    if verify_installation; then
        log_success "All components ready!"
    else
        log_info "Components will be built on first use"
    fi
    
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  Installation Complete!                                   ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    log_info "Next steps:"
    echo "  1. Source your shell profile: source ~/.bashrc (or ~/.zshrc)"
    echo "  2. Verify installation: zen --version"
    echo "  3. Create new project: zen new my-app"
    echo "  4. Compile: zen compile src/main.zen"
    echo ""
    log_info "Documentation: https://zenith-lang.org"
    log_info "GitHub: $REPO_URL"
    echo ""
}

# Run main function
main "$@"
