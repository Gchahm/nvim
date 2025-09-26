# Neovim Configuration

A complete Neovim configuration with custom bashrc, terminal themes, and plugin management using Lazy.nvim.

## Features

- 🚀 Modern Neovim setup with Lazy.nvim plugin manager
- 🎨 Custom terminal themes and configurations
- 🔧 Custom bashrc with development tools integration
- 📦 Pre-configured LSP, treesitter, and other essential plugins
- 🔄 Easy installation and uninstallation scripts

## Installation

### Quick Install

1. Clone this repository anywhere on your system:
```bash
git clone <your-repo-url> ~/nvim-config
cd ~/nvim-config
```

2. Run the installation script:
```bash
chmod +x install.sh
./install.sh
```

3. Follow the interactive prompts to complete the setup.

### What the installer does:

- ✅ Backs up your existing nvim configuration (if any)
- ✅ Copies all nvim configuration files to `~/.config/nvim`
- ✅ Sets up custom bashrc integration
- ✅ Copies terminal themes and configurations
- ✅ Checks for Node.js and provides setup instructions
- ✅ Provides clear next steps

### Post-Installation

1. **Restart your terminal** or run:
   ```bash
   source ~/.profile
   ```

2. **Install Node.js** (required for some plugins):
   ```bash
   nvm install 20
   nvm use 20
   ```
   
   If you don't have nvm installed:
   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   ```

3. **Start Neovim** and let Lazy.nvim install all plugins:
   ```bash
   nvim
   ```

## Uninstallation

To remove the configuration and revert changes:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

The uninstaller will:
- Remove the nvim configuration
- Optionally restore from backups
- Clean up bashrc integration
- Provide cleanup guidance

## Manual Installation (Legacy)

If you prefer to install manually:

1. Clone directly to nvim config directory:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

2. Add bashrc integration:
   ```bash
   echo "source ~/.config/nvim/.bashrc" >> ~/.profile
   ```

3. Install Node.js and start nvim as described above.

## Requirements

- Neovim (>= 0.8.0)
- Git
- Node.js (for LSP and some plugins)
- A terminal that supports true colors

## Troubleshooting

### Plugin Installation Issues
If plugins fail to install, try:
```bash
nvim --headless "+Lazy! sync" +qa
```

### Backup Recovery
Your old configurations are automatically backed up to `~/.config/nvim.backup.TIMESTAMP`. You can restore them using the uninstall script or manually.

### Node.js Issues
Some plugins require Node.js. Ensure you have it installed and active:
```bash
node --version  # Should show a version number
```

## Project Structure

```
.
├── install.sh              # Installation script
├── uninstall.sh            # Uninstallation script
├── init.lua                # Main nvim configuration
├── lazy-lock.json          # Plugin version lock file
├── luarc.json             # Lua language server config
├── .bashrc                # Custom bash configuration
├── .terminal/             # Terminal themes and configs
│   └── posh_themes/       # PowerShell themes
├── lua/                   # Lua configuration modules
│   └── gustavoch/         # Main configuration namespace
└── after/                 # After-load configurations
    └── ftplugin/          # Filetype-specific plugins
```
