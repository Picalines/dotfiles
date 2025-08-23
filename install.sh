#!/bin/bash

mkdir -p ~/.config

command-exists() {
  command -v "$1" &> /dev/null
}

symlink-from-to() {
    mkdir -p "$(dirname $2)"
    ln -snf "$PWD/$1" "$2"
}

symlink-from-to ./.bashrc ~/.bashrc
symlink-from-to ./.zshrc ~/.zshrc
symlink-from-to ./.gitconfig ~/.gitconfig

if command-exists nvim
then
    symlink-from-to ./nvim ~/.config/nvim
fi

if command-exists aerospace
then
    symlink-from-to ./aerospace.toml ~/.config/aerospace/aerospace.toml
fi

if command-exists alacritty
then
    symlink-from-to ./alacritty.toml ~/.config/alacritty/alacritty.toml
fi

if command-exists ghostty
then
    symlink-from-to ./ghostty.config ~/.config/ghostty/config
fi

if command-exists neovide
then
    symlink-from-to ./neovide.toml ~/.config/neovide/config.toml
fi

if command-exists starship
then
    symlink-from-to ./starship.toml ~/.config/starship.toml
fi
