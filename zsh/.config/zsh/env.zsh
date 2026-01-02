# ==============================================================================
# Zsh Environments
# DaikieJP - 2026
# ==============================================================================

# ==============================================================================
# PATH
# ==============================================================================

typeset -U path
path=(
  $HOME/.local/bin
  $HOME/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  $path
)
export PATH

# ==============================================================================
# Language
# ==============================================================================

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ==============================================================================
# Editor & Pager
# ==============================================================================

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R -F -X"

# ==============================================================================
# Colors
# ==============================================================================

export CLICOLOR=1
if [[ $OS_TYPE == "macos" ]]; then
  export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
else
  export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;43'
fi

# ==============================================================================
# GPG 
# ==============================================================================

export GPG_TTY=$TTY

# ==============================================================================
# History
# ==============================================================================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000000

setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# ==============================================================================
# History Search
# ==============================================================================

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search 
bindkey "^[[B" down-line-or-beginning-search 

# ==============================================================================
# Zoxide
# ==============================================================================

eval "$(zoxide init zsh)"

# ==============================================================================
# FZF
# ==============================================================================

export FZF_DEFAULT_OPTS="
  --height 40% 
  --layout=reverse 
  --border 
  --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}'
  --preview-window right:60%
"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ==============================================================================
# Starship
# ==============================================================================

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
