#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Install oh-my-posh if not present
if ! command -v oh-my-posh &> /dev/null; then
    echo "Installing oh-my-posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
else
    echo "oh-my-posh is already installed."
fi

THEME="honukai"
THEME_PATH="${REPO_DIR}/nvim/.terminal/posh_themes/${THEME}.omp.json"
INIT_LINE='eval "$(oh-my-posh init bash --config '"${THEME_PATH}"')"'

# Add to ~/.bashrc if not already present
if [ -f "$HOME/.bashrc" ] && grep -q "oh-my-posh init" "$HOME/.bashrc"; then
    echo "oh-my-posh init already in ~/.bashrc"
else
    echo "" >> "$HOME/.bashrc"
    echo "# oh-my-posh prompt" >> "$HOME/.bashrc"
    echo "$INIT_LINE" >> "$HOME/.bashrc"
    echo "Added oh-my-posh init to ~/.bashrc"
fi

echo "Done. Restart your terminal or run: source ~/.bashrc"
