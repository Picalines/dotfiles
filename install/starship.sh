#!/bin/sh

ln -s $(realpath ~/.bashrc) $(realpath ./.bashrc)
ln -s $(realpath ~/.zshrc) $(realpath ./.zshrc)

ln -s $(realpath ./starship.toml) $(realpath ~/.config/starship.toml)

