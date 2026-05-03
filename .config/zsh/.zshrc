if [[ ! -d "${XDG_CACHE_HOME}"/zsh ]]; then
  mkdir -p "${XDG_CACHE_HOME}"/zsh
fi

if [[ ! -d "${XDG_STATE_HOME}"/zsh ]]; then
  mkdir -p "${XDG_STATE_HOME}"/zsh
fi

# <-- Fastfetch -->
if [[ ! -r "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/logo" ]]; then
  pokeget venomoth --hide-name > "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/logo"
fi
fastfetch --file-raw $XDG_CACHE_HOME/zsh/logo

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# <-- History -->
HISTSIZE=50000
HISTFILE="${XDG_STATE_HOME}"/zsh/history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# <-- Completions -->
autoload -Uz compinit; compinit -d "${XDG_CACHE_HOME}"/zsh/zcompdump-"${ZSH_VERSION}"

# <-- PLUGINS -->
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# <-- KEYBINDS -->
# bindkey -e
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
# bindkey '^[w' kill-region

# <-- Styling -->
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'

# <-- Aliases -->
alias "ls"="eza --icons=always"
alias "ll"="eza -la --icons=always"
alias "nv"="nvim"
alias "lg"="lazygit"
alias "o"="xdg-open"
alias "Hyprland"="start-hyprland"

# <-- Shell integrations -->
eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
