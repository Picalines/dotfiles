#!/bin/zsh

if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  export PATH="$(brew --prefix)/opt/python@3.12/libexec/bin:$PATH"
fi

autoload -U add-zsh-hook

command-exists() {
  command -v "$1" &> /dev/null
}

command-exists cargo && source "$HOME/.cargo/env"
command-exists starship && source <(starship init zsh)
command-exists fzf && source <(fzf --zsh)
command-exists pnpm && source <(pnpm completion zsh)
command-exists nvim && export EDITOR="$(which nvim)"

autoload -Uz compinit && compinit

alias vi=nvim
alias vim=nvim
alias nv=nvim
alias python=python3

# terminal title
update-term-title() {
  local title="$(basename $PWD)"
  echo -ne "\033]0;$title\007"
}

add-zsh-hook chpwd update-term-title
update-term-title

# auto .nvmrc
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# auto venv
load-venv() {
  if [[ -z "$VIRTUAL_ENV" ]]; then
    if [[ -f ./venv/bin/activate ]]; then
      source ./venv/bin/activate
    fi
  else
    local parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != "$parentdir"/* ]]; then
      deactivate
    fi
  fi
}

add-zsh-hook chpwd load-venv
load-venv

# OSC 133
# https://github.com/starship/starship/issues/5463

__prompt_precmd() {
    local ret="$?"
    if [[ "$_prompt_executing" != "0" ]]
    then
      _PROMPT_SAVE_PS1="$PS1"
      _PROMPT_SAVE_PS2="$PS2"
      PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
      PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
    fi
    if [[ "$_prompt_executing" != "" ]]
    then
       printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
    fi
    printf "\033]133;A;cl=m;aid=%s\007" "$$"
    _prompt_executing=0
}

__prompt_preexec() {
    PS1="$_PROMPT_SAVE_PS1"
    PS2="$_PROMPT_SAVE_PS2"
    printf "\033]133;C;\007"
    _prompt_executing=1
}

preexec_functions+=(__prompt_preexec)
precmd_functions+=(__prompt_precmd)

