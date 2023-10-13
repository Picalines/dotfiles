#!/bin/bash

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

### FUNCTIONS

function mkcd
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

function chr
{
    echo "$@" | awk '{for (i = 1; i <= NF; i++) {printf("%c", strtonum($i))}}'
}

function is_windows
{
    [[ -n "$WINDIR" ]];
}

### STARTUP

## prompt

# old custom
# PS1="\e[36m\w\$(__git_ps1 ' \e[32m(%s)') \e[33m→\e[39m "

# oh-my-posh
# eval "$(oh-my-posh init bash --config ~/.config.omp.json)"

# starship
if command -v starship &> /dev/null
then
    eval "$(starship init bash)"
fi

clear
