# shellcheck shell=sh

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"

export VISUAL="nvim -b"
export EDITOR="nvim -b"

[ -f ~/.config/posix-work/profile.sh ] && . ~/.config/posix-work/profile.sh
[ -f ~/.config/posix-local/profile.sh ] && . ~/.config/posix-local/profile.sh
