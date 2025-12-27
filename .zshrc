#!/bin/zsh

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$PATH"

autoload -U add-zsh-hook
autoload -Uz compinit && compinit

command-exists() {
  command -v "$1" &> /dev/null
}

command-exists cargo && source "$HOME/.cargo/env"
command-exists starship && source <(starship init zsh)
command-exists fzf && source <(fzf --zsh)
command-exists mise && source <(mise activate zsh)
command-exists pnpm && source <(pnpm completion zsh)
command-exists zoxide && source <(zoxide init zsh)

if command-exists nvim; then
  export VISUAL="nvim -b"
  export EDITOR="nvim -b"

  alias vi=nvim
  alias vim=nvim
  alias nv=nvim
  alias e=nvim
fi

alias python=python3

# terminal title
update-term-title() {
  local title="$(basename $PWD)"
  echo -ne "\033]0;$title\007"
}

add-zsh-hook chpwd update-term-title
update-term-title
