#!/bin/zsh

if [[ -f ~/.zsh_aliases ]]; then
    source ~/.zsh_aliases
fi

# starship
if command -v starship &> /dev/null
then
    eval "$(starship init zsh)"
fi

# fzf
if command -v fzf &> /dev/null
then
  source <(fzf --zsh)
fi

# cargo
if [ -f "$HOME/.cargo/env" ];
then
  source "$HOME/.cargo/env"
fi

# arc
if command -v arc &> /dev/null
then
  export ARC_TOKEN="$(arc token show)"
fi

# auto .nvmrc

autoload -U add-zsh-hook

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

