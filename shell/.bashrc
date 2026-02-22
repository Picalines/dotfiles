# old custom prompt. Simpler times :)
# PS1="\e[36m\w\$(__git_ps1 ' \e[32m(%s)') \e[33m→\e[39m "

set -o emacs

command-exists() {
  command -v "$1" &> /dev/null
}

[ -f ~/.bash_aliases ] &&  source ~/.bash_aliases
[ -f ~/.cargo/env ] && source ~/.cargo/env

if command-exists mise; then
  if [[ "$OSTYPE" == "msys" ]]; then
    # https://github.com/jdx/mise/discussions/3961
    eval "$(mise activate bash --shims | sed -e 's/="C:\\/="\/c\//')"
  else
    eval "$(mise activate bash --shims)"
  fi
fi

command-exists starship && eval "$(starship init bash)"
command-exists pnpm && eval "$(pnpm completion bash)"
command-exists fzf && eval "$(fzf --bash)"
command-exists zoxide && eval "$(zoxide init bash)"

if command-exists nvim; then
  export VISUAL="nvim -b"
  export EDITOR="nvim -b"

  alias vi=nvim
  alias vim=nvim
  alias nv=nvim
  alias e=nvim
fi

command-exists yazi && alias f=yazi

alias python=python3
