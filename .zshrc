#!/bin/zsh

if [[ -f ~/.zsh_aliases ]]; then
    source ~/.zsh_aliases
fi

# starship
if command -v starship &> /dev/null
then
    eval "$(starship init zsh)"
fi

