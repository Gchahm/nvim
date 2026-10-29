[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
[[ "$OSTYPE" == darwin* && -f "$HOME/.zshrc.mac" ]] && source "$HOME/.zshrc.mac"

setopt interactive_comments
# Zsh configuration file

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# Enable auto-completion
autoload -Uz compinit
compinit

# Enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# fnm (Fast Node Manager)
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias v='nvim'

# Prompt customization (simple)
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%b'
PROMPT='%F{cyan}%n@%m%f:%F{yellow}%~%f %F{green}${vcs_info_msg_0_}%f$ '

# Path additions (add your custom paths here)
# export PATH="$HOME/bin:$PATH"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
