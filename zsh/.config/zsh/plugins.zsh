# ==============================================================================
# Zsh Plugins
# DaikieJP - 2026
# ==============================================================================

# ==============================================================================
# Autocompletion
# ==============================================================================

autoload -Uz compinit
compinit

# Speed optimization: Only check cache once per day
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi

# ==============================================================================
# Completion Styles
# ==============================================================================

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ==============================================================================
# Autosuggestions & Syntax Highlighting 
# ==============================================================================

source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

