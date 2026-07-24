# startup banner
fastfetch

# completion system (needed before plugins that register completions)
autoload -Uz compinit && compinit

# antidote plugin manager
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# fzf-tab: preview files/dirs during tab-completion, same as fzf's Ctrl+T
zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -d $realpath ]] && eza --tree --icons --color=always --level=2 $realpath || bat --color=always --style=numbers --line-range=:500 $realpath 2>/dev/null'

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='code --wait'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Shell aliases
alias reload="source ~/.zshrc"
alias zshrc="open ~/.zshrc"

# eza (modern ls replacement — requires Nerd Font)
alias ls="eza --icons"
alias ll="eza -lh --icons --git"
alias la="eza -lah --icons --git"
alias lt="eza --tree --icons --level=2"
alias lta="eza --tree --icons --level=2 -a"

# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# fzf (Ctrl+R history, Ctrl+T file search, Alt+C cd) — previews via bat/eza
export FZF_CTRL_T_OPTS="--preview '[[ -d {} ]] && eza --tree --icons --color=always --level=2 {} || bat --color=always --style=numbers --line-range=:500 {}' --preview-window=right:60%"
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always --level=2 {}'"
source <(fzf --zsh)

# atuin (searchable history DB) — up/down arrow both open atuin's search
eval "$(atuin init zsh)"
bindkey '^[[B' atuin-up-search
bindkey '^[OB' atuin-up-search

# Navigation aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
export PATH="$HOME/.local/bin:$PATH"

alias hdm='hunk diff origin/main...HEAD'

# Open current directory in Finder
alias finder="open ."

# Stop all running Docker containers (e.g. leftover Supabase worktree stacks)
alias dockstop='docker stop $(docker ps -q)'


# Apple Silicon Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.deno/bin:$PATH"

# starship prompt
eval "$(starship init zsh)"

# direnv (auto-load/unload per-directory env vars from .envrc)
eval "$(direnv hook zsh)"

# machine-specific secrets/env vars, not tracked in dotfiles repo
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# --- pi coding agent: locked-down work root alias (added 2026-07-24) ---
alias pi-work='PI_CODING_AGENT_DIR="$HOME/.pi/agent-work" pi'
# --- end pi coding agent work root alias ---
