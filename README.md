# dotfiles

Personal configuration for neovim and tmux, symlinked into place by a single script.

## Install

```bash
git clone <repo-url> ~/code/dotfiles
cd ~/code/dotfiles
./install.sh
```

`install.sh` is idempotent. Existing files are moved to `<target>.backup.<timestamp>`, and each action is printed (`link`, `ok`, `backup`, `skip`). It needs only `bash`, `ln`, `mkdir`, `mv` (plus `git` to fetch the tmux plugin manager).

Optionally install the tools these configs expect (neovim 0.11+, ripgrep, tmux, fzf, starship, nvm) with `./scripts/packages.sh` (Homebrew on macOS, apt on Linux).

## Layout

| Path in repo | Linked to |
|---|---|
| `.tmux.conf` | `~/.tmux.conf` |
| `nvim/` | `~/.config/nvim` |
| `tmux/` | `~/.config/tmux` |

To add a config, drop it in the repo and add a line to `LINKS` in `install.sh`.

## Uninstall

```bash
./uninstall.sh
```

Removes the symlinks pointing into this repo and restores the newest backup, if any.

## Notes

- After first install, open tmux and press `prefix + I` to install plugins; open `nvim` to let lazy.nvim sync.
- `nvim --headless "+Lazy! sync" +qa` re-syncs plugins from the command line.
