# Neovim Configuration

A complete Neovim configuration with Lazy.nvim plugin management, LSP, treesitter, and more.

## Quick Start

```bash
git clone <your-repo-url> ~/nvim-config
cd ~/nvim-config

# Install dependencies (Neovim 0.11+, ripgrep, lua, etc.)
./scripts/install-dependencies.sh

# Symlink the config to ~/.config/nvim
./scripts/add-symlink.sh

# Start Neovim and let Lazy.nvim install plugins
nvim
```

## Scripts

All scripts live in `scripts/` and support both macOS (Homebrew) and Linux (apt).

| Script | Purpose |
|---|---|
| `install-dependencies.sh` | Installs Neovim 0.11+ and all build dependencies |
| `add-symlink.sh` | Links `~/.config/nvim` to this repo (backs up existing config) |
| `remove-symlink.sh` | Removes the symlink and cleans up bashrc integration |
| `install-ohmyposh.sh` | Optional: installs oh-my-posh with the honukai theme |

## Requirements

- Neovim >= 0.11 (installed by `install-dependencies.sh`)
- Git
- A terminal that supports true colors

## Uninstallation

```bash
./scripts/remove-symlink.sh
```

This will remove the symlink, clean up bashrc integration, and optionally restore a backup.

## Troubleshooting

### Plugin Installation Issues
```bash
nvim --headless "+Lazy! sync" +qa
```

### Backup Recovery
Old configurations are backed up to `~/.config/nvim.backup.TIMESTAMP`. Restore them with `remove-symlink.sh` or manually.

## Project Structure

```
.
├── scripts/
│   ├── install-dependencies.sh   # Install Neovim + dependencies
│   ├── add-symlink.sh            # Symlink config into place
│   ├── remove-symlink.sh         # Remove symlink and clean up
│   └── install-ohmyposh.sh       # Optional oh-my-posh setup
├── nvim/                          # Neovim configuration
│   ├── init.lua                   # Entry point
│   ├── lazy-lock.json             # Plugin version lock
│   ├── .bashrc                    # Shell aliases and env vars
│   ├── .terminal/                 # Terminal themes
│   ├── lua/gustavoch/             # Configuration modules
│   └── after/ftplugin/            # Filetype-specific settings
└── README.md
```

The `nvim/` directory is symlinked to `~/.config/nvim/`, so changes in the repo are immediately live.
