# old custom prompt. Simpler times :)
# PS1="\e[36m\w\$(__git_ps1 ' \e[32m(%s)') \e[33m→\e[39m "

set -o emacs

command-exists() {
  command -v "$1" &> /dev/null
}

[ -f ~/.bash_aliases ] &&  source ~/.bash_aliases
[ -f ~/.cargo/env ] && source ~/.cargo/env
command-exists starship && source <(starship init bash)
command-exists mise && source <(mise activate bash --shims)
command-exists pnpm && source <(pnpm completion bash)
command-exists fzf && source <(fzf --bash)
command-exists zoxide && source <(zoxide init bash)

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
