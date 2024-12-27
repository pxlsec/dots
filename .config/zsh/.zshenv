export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_CACHE_HOME="$HOME"/.cache

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup 
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# C#
export OMNISHARPHOME="$XDG_CONFIG_HOME"/omnisharp 
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages 

# Haskell
export GHCUP_USE_XDG_DIRS=true
export STACK_XDG=1 

# GO
export GOPATH="$XDG_DATA_HOME"/go 

# Java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle 

# Python
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc

# JS
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc

# System
export XCURSOR_PATH=/usr/share/icons:$XDG_DATA_HOME/icons
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo

# Wine
export WINEPREFIX="$XDG_DATA_HOME"/wine

# GPG
#export GNUPGHOME="$XDG_DATA_HOME"/gnupg 

# Pass
# export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
