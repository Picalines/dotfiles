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

# syntax: symlink $linkname $target
function symlink
{
    if [[ -z "$2" ]]; then
        # Link-checking mode.
        if is_windows; then
            fsutil reparsepoint query "$1" > /dev/null
        else
            [[ -h "$1" ]]
        fi
    else
        # Link-creation mode.
        if is_windows; then
            if [[ -d "$2" ]]; then
                cmd <<< "mklink /D $1 ${2//\//\\}" > /dev/null
            else
                cmd <<< "mklink $1 ${2//\//\\}" > /dev/null
            fi
        else
            ln -s "$2" "$1"
        fi
    fi
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
