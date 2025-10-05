#!/bin/bash

set -e

command-exists() {
  command -v "$1" &> /dev/null
}

symlink-from-to() {
    echo "linking '$1' to '$2'"
    if [[ -n $WINDIR ]]; then
        powershell "New-Item -Type SymbolicLink -Path $2 -Value $1 -Force" > /dev/null
    else
        mkdir -p "$(dirname $2)"
        ln -snf "$PWD/$1" "$2"
    fi
}

symlink-from-to ".bashrc" "~/.bashrc"
symlink-from-to ".gitconfig" "~/.gitconfig"
symlink-from-to ".gitignore.global" "~/.gitignore"

command-exists zsh && symlink-from-to ".zshrc" "~/.zshrc"
command-exists nvim && symlink-from-to "nvim" "~/.config/nvim"
command-exists aerospace && symlink-from-to "aerospace.toml" "~/.config/aerospace/aerospace.toml"
command-exists alacritty && symlink-from-to "alacritty.toml" "~/.config/alacritty/alacritty.toml"
command-exists ghostty && symlink-from-to "ghostty.config" "~/.config/ghostty/config"
command-exists neovide && symlink-from-to "neovide.toml" "~/.config/neovide/config.toml"
command-exists starship && symlink-from-to "starship.toml" "~/.config/starship.toml"
[ -d ~/.glzr/glazewm ] && symlink-from-to "glazewm.yaml" "~/.glzr/glazewm/config.yaml"
