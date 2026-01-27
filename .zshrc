set -o emacs

autoload -U add-zsh-hook
autoload -Uz compinit && compinit

command-exists() {
  command -v "$1" &> /dev/null
}

command-exists cargo && source "$HOME/.cargo/env"
command-exists mise && eval "$(mise activate zsh --shims)"
command-exists starship && eval "$(starship init zsh)"
command-exists fzf && source <(fzf --zsh)
command-exists pnpm && eval "$(pnpm completion zsh)"
command-exists zoxide && eval "$(zoxide init zsh)"

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

# Edit command in the editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# terminal title
update-term-title() {
  local title="$(basename $PWD)"
  echo -ne "\033]0;$title\007"
}

add-zsh-hook chpwd update-term-title
update-term-title

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
