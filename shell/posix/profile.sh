# shellcheck shell=sh

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

[ -f ~/.config/posix-work/profile.sh ] && . ~/.config/posix-work/profile.sh
[ -f ~/.config/posix-local/profile.sh ] && . ~/.config/posix-local/profile.sh
