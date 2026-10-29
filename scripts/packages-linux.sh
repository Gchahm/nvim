# Linux package install. Sourced by packages.sh (uses its print_* helpers).
# apt packages come from apt-packages.txt; neovim, fnm and starship are
# installed from upstream because apt versions are old or missing.

NVIM_REQUIRED_MAJOR=0
NVIM_REQUIRED_MINOR=11

install_apt_packages() {
    local file="$SCRIPT_DIR/apt-packages.txt"
    local missing=() pkg
    while read -r pkg; do
        [ -z "$pkg" ] && continue
        dpkg -s "$pkg" &> /dev/null || missing+=("$pkg")
    done < "$file"

    if [ ${#missing[@]} -eq 0 ]; then
        print_success "apt packages already installed."
        return
    fi
    print_info "Installing: ${missing[*]}"
    sudo apt update
    sudo apt install -y "${missing[@]}"
}

install_neovim() {
    local arch asset
    arch="$(uname -m)"
    case "$arch" in
        x86_64)  asset="nvim-linux-x86_64.tar.gz" ;;
        aarch64) asset="nvim-linux-arm64.tar.gz" ;;
        *)
            print_error "Unsupported architecture: $arch"
            print_info "Install Neovim 0.11+ manually: https://github.com/neovim/neovim/releases"
            exit 1
            ;;
    esac

    local tmp_dir
    tmp_dir="$(mktemp -d)"
    print_info "Downloading $asset..."
    curl -fsSL -o "$tmp_dir/nvim.tar.gz" \
        "https://github.com/neovim/neovim/releases/latest/download/$asset"
    mkdir -p "$HOME/.local"
    tar -C "$HOME/.local" --strip-components=1 -xzf "$tmp_dir/nvim.tar.gz"
    rm -rf "$tmp_dir"
    export PATH="$HOME/.local/bin:$PATH"
    print_success "Neovim installed to $HOME/.local/bin/nvim"
}

check_neovim() {
    if command -v nvim &> /dev/null; then
        local ver major minor
        ver="$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)"
        major="${ver%%.*}"
        minor="${ver##*.}"
        if [ "$major" -gt "$NVIM_REQUIRED_MAJOR" ] || \
           { [ "$major" -eq "$NVIM_REQUIRED_MAJOR" ] && [ "$minor" -ge "$NVIM_REQUIRED_MINOR" ]; }; then
            print_success "Neovim $ver detected."
            return
        fi
        print_warning "Neovim $ver is too old (need 0.11+)."
    fi
    install_neovim
}

install_fnm() {
    if command -v fnm &> /dev/null; then
        print_success "fnm is already installed."
        return
    fi
    print_info "Installing fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
}

install_starship() {
    if command -v starship &> /dev/null; then
        print_success "starship is already installed."
        return
    fi
    print_info "Installing starship..."
    mkdir -p "$HOME/.local/bin"
    curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
}

install_apt_packages
check_neovim
install_fnm
install_starship

if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
    print_warning "Your login shell is not zsh. To switch: chsh -s \"$(command -v zsh)\" (then log out and back in)."
fi
