# ==============================================================================
# Zsh Plugins
# DaikieJP - 2026
#
# chezmoi clones the plugins as externals (.chezmoiexternal.toml); there is
# nothing to install by hand.
# ==============================================================================

# ==============================================================================
# Autocompletion
# The dump is regenerated at most once a day; every other startup reuses the
# cache (compinit -C), which is noticeably faster.
# ==============================================================================

autoload -Uz compinit

if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qNmh-24) ]]; then
  compinit -C
else
  compinit
fi

# ==============================================================================
# Completion Styles
# ==============================================================================

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ==============================================================================
# Autosuggestions & Syntax Highlighting
# Order matters: syntax-highlighting has to be sourced last.
# ==============================================================================

ZSH_PLUGIN_DIR="${HOME}/.config/zsh/plugins"

[ -f "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ] \
  && source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

[ -f "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] \
  && source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

unset ZSH_PLUGIN_DIR
