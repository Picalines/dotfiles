#!/bin/bash

set -e

command-exists() {
  command -v "$1" &> /dev/null
}

symlink-to-home() {
    echo "linking '$1' to '~/$2'"
    if [[ -n $WINDIR ]]; then
        powershell "New-Item -Type SymbolicLink -Path ~/$2 -Value $1 -Force" > /dev/null
    else
        mkdir -p "$(dirname "$HOME/$2")"
        ln -snf "$PWD/$1" "$HOME/$2"
    fi
}

symlink-to-home ".bashrc" ".bashrc"
symlink-to-home ".gitconfig" ".gitconfig"
symlink-to-home ".gitignore.global" ".gitignore"

command-exists zsh && symlink-to-home ".zshrc" ".zshrc"
command-exists nvim && symlink-to-home "nvim" ".config/nvim"
command-exists aerospace && symlink-to-home "aerospace.toml" ".config/aerospace/aerospace.toml"
command-exists alacritty && symlink-to-home "alacritty.toml" ".config/alacritty/alacritty.toml"
command-exists ghostty && symlink-to-home "ghostty" ".config/ghostty"
command-exists neovide && symlink-to-home "neovide.toml" ".config/neovide/config.toml"
command-exists starship && symlink-to-home "starship.toml" ".config/starship.toml"
command-exists zellij && symlink-to-home "zellij" ".config/zellij"
[ -d ~/.glzr/glazewm ] && symlink-to-home "glazewm.yaml" ".glzr/glazewm/config.yaml"
symlink-to-home "tmux" ".config/tmux"
