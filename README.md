# dotfiles

Personal configuration for neovim and tmux, symlinked into place by a single script.

## Install

```bash
git clone <repo-url> ~/code/dotfiles
cd ~/code/dotfiles
./bootstrap.sh
```

`bootstrap.sh` installs packages (`scripts/packages.sh`), then links the dotfiles (`link.sh`). GitHub Codespaces runs it automatically as the dotfiles install script. To refresh just the symlinks, run `./link.sh`.

`link.sh` is idempotent. Existing files are moved to `<target>.backup.<timestamp>`, and each action is printed (`link`, `ok`, `backup`, `skip`). It needs only `bash`, `ln`, `mkdir`, `mv` (plus `git` to fetch the tmux plugin manager).

`packages.sh` installs the tools these configs expect (neovim 0.11+, ripgrep, tmux, fzf, fnm, starship, zsh-autosuggestions). On macOS it runs `brew bundle` against `Brewfile`; on Linux it installs `scripts/apt-packages.txt` with apt, plus neovim, fnm and starship from upstream (`scripts/packages-linux.sh`). To add a tool, edit the Brewfile and the apt list.

## Layout

| Path in repo | Linked to |
|---|---|
| `.gitconfig` | `~/.gitconfig` |
| `.zshrc` | `~/.zshrc` |
| `.zshrc.mac` | `~/.zshrc.mac` (sourced only when `$OSTYPE` is darwin) |
| `nvim/` | `~/.config/nvim` |
| `tmux/` | `~/.config/tmux` |

Secrets and machine-specific settings go in `~/.zshrc.local`, which is sourced by `.zshrc` if present but never tracked.

To add a config, drop it in the repo and add a line to `LINKS` in `link.sh`.

## Uninstall

```bash
./uninstall.sh
```

Removes the symlinks pointing into this repo and restores the newest backup, if any.

## Notes

- After first install, open tmux and press `prefix + I` to install plugins; open `nvim` to let lazy.nvim sync.
- `nvim --headless "+Lazy! sync" +qa` re-syncs plugins from the command line.
