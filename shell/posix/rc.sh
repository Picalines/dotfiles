# shellcheck shell=sh

alias g=git
alias gg=lazygit

alias m=mise
alias mr="mise run"
alias me="mise exec"

alias vi=nvim
alias vim=nvim
alias nv=nvim
alias e=nvim

alias oc=opencode
alias occ="opencode -c"

[ -f ~/.config-work/posix/rc.sh ] && . ~/.config-work/posix/rc.sh
[ -f ~/.config-local/posix/rc.sh ] && . ~/.config-local/posix/rc.sh
