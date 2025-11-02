#!/bin/bash

# old custom prompt. Simpler times :)
# PS1="\e[36m\w\$(__git_ps1 ' \e[32m(%s)') \e[33m→\e[39m "

export PATH="$HOME/.local/bin:$PATH"

command-exists() {
  command -v "$1" &> /dev/null
}

[ -f ~/.bash_aliases ] &&  source ~/.bash_aliases
[ -f ~/.cargo/env ] && source ~/.cargo/env
command-exists starship && source <(starship init bash)
command-exists pnpm && source <(pnpm completion bash)
command-exists fzf && source <(fzf --bash)
command-exists nvim && export EDITOR="nvim -b" && export VISUAL="nvim -b" && export MANPAGER="nvim +Man!"
command-exists zoxide && source <(zoxide init bash)

alias vi=nvim
alias vim=nvim
alias nv=nvim
alias python=python3
