#!/bin/bash

# Installs the tools these dotfiles expect (optional; install.sh does not need it).
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

# --- fnm / Node.js ---

install_fnm() {
    if command -v fnm &> /dev/null; then
        print_success "fnm is already installed."
        return
    fi
    print_info "Installing fnm..."
    case "$OS" in
        Darwin)
            ensure_brew
            brew install fnm
            ;;
        Linux)
            curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
            ;;
    esac
    print_success "fnm installed. Restart your terminal, then run: fnm install --lts"
}

# --- starship prompt ---

install_starship() {
    if command -v starship &> /dev/null; then
        print_success "starship is already installed."
        return
    fi
    print_info "Installing starship..."
    case "$OS" in
        Darwin)
            ensure_brew
            brew install starship
            ;;
        Linux)
            mkdir -p "$HOME/.local/bin"
            curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
            ;;
    esac
    print_success "starship installed. Icons need a Nerd Font in your terminal."
}

# --- zsh-autosuggestions (a zsh plugin, not a command) ---

install_autosuggestions() {
    case "$OS" in
        Darwin)
            ensure_brew
            if brew list zsh-autosuggestions &> /dev/null; then
                print_success "zsh-autosuggestions is already installed."
            else
                print_info "Installing zsh-autosuggestions..."
                brew install zsh-autosuggestions
            fi
            ;;
        Linux)
            if dpkg -s zsh-autosuggestions &> /dev/null; then
                print_success "zsh-autosuggestions is already installed."
            else
                print_info "Installing zsh-autosuggestions..."
                ensure_apt_updated
                sudo apt install -y zsh-autosuggestions
            fi
            ;;
    esac
}

# --- Main ---

echo
print_info "Installing packages for $(uname -s)..."
echo

check_neovim

#         cmd       brew pkg      apt pkg
install_pkg make     make          make
install_pkg rg       ripgrep       ripgrep
install_pkg tmux     tmux          tmux
install_pkg fzf      fzf           fzf

install_fnm
install_starship
install_autosuggestions

echo
print_success "All dependencies installed!"
print_info "If fnm was just installed, restart your terminal and run: fnm install --lts"
