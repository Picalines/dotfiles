# shellcheck shell=sh

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DIRS="$HOME/.config-local:$HOME/.config-work:$XDG_CONFIG_DIRS"

export VISUAL="nvim -b"
export EDITOR="nvim -b"

[ -f ~/.config-work/posix/profile.sh ] && . ~/.config-work/posix/profile.sh
[ -f ~/.config-local/posix/profile.sh ] && . ~/.config-local/posix/profile.sh
