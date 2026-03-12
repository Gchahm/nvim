#!/bin/bash

# Installs all dependencies needed for the Neovim configuration.
# Supports macOS (Homebrew) and Linux (apt).

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

OS="$(uname -s)"
NVIM_REQUIRED_MAJOR=0
NVIM_REQUIRED_MINOR=11

# --- Package manager helpers ---

ensure_brew() {
    if ! command -v brew &> /dev/null; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

apt_updated=false
ensure_apt_updated() {
    if [ "$apt_updated" = false ]; then
        print_info "Updating apt package list..."
        sudo apt update
        apt_updated=true
    fi
}

install_pkg() {
    local cmd="$1"
    local brew_pkg="${2:-$1}"
    local apt_pkg="${3:-$1}"

    if command -v "$cmd" &> /dev/null; then
        print_success "$cmd is already installed."
        return
    fi

    print_info "Installing $cmd..."
    case "$OS" in
        Darwin)
            ensure_brew
            brew install "$brew_pkg"
            ;;
        Linux)
            ensure_apt_updated
            sudo apt install -y "$apt_pkg"
            ;;
        *)
            print_error "Unsupported OS: $OS"
            exit 1
            ;;
    esac
    print_success "$cmd installed."
}

# --- Neovim ---

install_neovim_linux() {
    local arch
    arch="$(uname -m)"
    case "$arch" in
        x86_64)  local nvim_asset="nvim-linux-x86_64.tar.gz" ;;
        aarch64) local nvim_asset="nvim-linux-arm64.tar.gz" ;;
        *)
            print_error "Unsupported architecture: $arch"
            print_info "Install Neovim 0.11+ manually: https://github.com/neovim/neovim/releases"
            exit 1
            ;;
    esac

    local install_dir="$HOME/.local"
    local tmp_dir
    tmp_dir="$(mktemp -d)"

    print_info "Downloading $nvim_asset..."
    curl -L -o "$tmp_dir/nvim.tar.gz" \
        "https://github.com/neovim/neovim/releases/latest/download/$nvim_asset"

    print_info "Extracting to $install_dir..."
    mkdir -p "$install_dir"
    tar -C "$install_dir" --strip-components=1 -xzf "$tmp_dir/nvim.tar.gz"
    rm -rf "$tmp_dir"

    export PATH="$HOME/.local/bin:$PATH"
    print_success "Neovim installed to $install_dir/bin/nvim"
    print_info "Make sure $HOME/.local/bin is in your PATH."
}

install_neovim() {
    print_info "Installing Neovim 0.11+ (stable)..."
    case "$OS" in
        Darwin)
            ensure_brew
            brew install neovim
            ;;
        Linux)
            install_neovim_linux
            ;;
    esac
}

check_neovim() {
    if command -v nvim &> /dev/null; then
        local nvim_ver
        nvim_ver="$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)"
        local nvim_major="${nvim_ver%%.*}"
        local nvim_minor="${nvim_ver##*.}"
        if [ "$nvim_major" -gt "$NVIM_REQUIRED_MAJOR" ] || \
           { [ "$nvim_major" -eq "$NVIM_REQUIRED_MAJOR" ] && [ "$nvim_minor" -ge "$NVIM_REQUIRED_MINOR" ]; }; then
            print_success "Neovim $nvim_ver detected."
            return
        fi
        print_warning "Neovim $nvim_ver is too old (need 0.11+)."
    else
        print_warning "Neovim is not installed."
    fi
    install_neovim
}

# --- nvm / Node.js ---

install_nvm() {
    if command -v nvm &> /dev/null || [ -d "$HOME/.nvm" ]; then
        print_success "nvm is already installed."
        return
    fi
    print_info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    print_success "nvm installed. Restart your terminal, then run: nvm install 20"
}

# --- Main ---

echo
print_info "Installing Neovim dependencies for $(uname -s)..."
echo

check_neovim

#         cmd       brew pkg      apt pkg
install_pkg make     make          make
install_pkg rg       ripgrep       ripgrep

install_nvm

NV_ALIAS='alias nv="nvim"'
if ! grep -qF "$NV_ALIAS" ~/.zshrc 2>/dev/null; then
    print_info "Adding 'nv' alias for nvim to ~/.zshrc..."
    echo "" >> ~/.zshrc
    echo "$NV_ALIAS" >> ~/.zshrc
    print_success "'nv' alias added to ~/.zshrc."
else
    print_success "'nv' alias already in ~/.zshrc."
fi

echo
print_success "All dependencies installed!"
print_info "If nvm was just installed, restart your terminal and run: nvm install 20"
