#!/bin/bash

ln -snf $PWD/.bashrc ~/.bashrc
ln -snf $PWD/.zshrc ~/.zshrc

mkdir -p ~/.config

command-exists() {
  command -v "$1" &> /dev/null
}

if command-exists nvim
then
    ln -snf $PWD/nvim ~/.config/nvim
fi

if command-exists aerospace
then
    mkdir -p ~/.config/aerospace
    ln -snf $PWD/aerospace.toml ~/.config/aerospace/aerospace.toml
fi

if command-exists alacritty
then
    mkdir -p ~/.config/alacritty
    ln -snf $PWD/alacritty.toml ~/.config/alacritty/alacritty.toml
fi

if command-exists ghostty
then
    mkdir -p ~/.config/ghostty
    ln -snf $PWD/ghostty.config ~/.config/ghostty/config
fi

if command-exists neovide
then
    mkdir -p ~/.config/neovide
    ln -snf $PWD/neovide.toml ~/.config/neovide/config.toml
fi

if command-exists starship
then
    ln -snf $PWD/starship.toml ~/.config/starship.toml
fi
