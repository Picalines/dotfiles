### FUNCTIONS

function mkcd
{
    mkdir -p -- "$1" && cd -P -- "$1"
}

function chr
{
    echo "$@" | awk '{for (i = 1; i <= NF; i++) {printf("%c", strtonum($i))}}'
}

### STARTUP

## prompt

# old custom
# PS1="\e[36m\w\$(__git_ps1 ' \e[32m(%s)') \e[33m→\e[39m "

# oh-my-posh
# eval "$(oh-my-posh init bash --config ~/.config.omp.json)"

# starship
eval "$(starship init bash)"

clear
