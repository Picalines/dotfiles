#!/bin/bash

command-exists() {
  command -v "$1" &> /dev/null
}

symlink-to-home() {
    echo "linking '$1' to '~/$2'"
    if [[ -n $WINDIR ]]; then
        powershell "New-Item -Type SymbolicLink -Path ~/$2 -Value $1 -Force"
    else
        mkdir -p "$(dirname "$HOME/$2")"
        ln -snf "$PWD/$1" "$HOME/$2"
    fi
}

if command-exists brew; then
    brew bundle --file=./Brewfile
fi

if command-exists scoop; then
    scoop import ./scoop.json
fi

if command-exists mise; then
    symlink-to-home "mise" ".config/mise"
    mise install
fi

symlink-to-home "./sh/.inputrc" ".inputrc"

command-exists bash && symlink-to-home "./sh/.bash_profile" ".bash_profile"
command-exists bash && symlink-to-home "./sh/.bashrc" ".bashrc"
command-exists zsh && symlink-to-home "./sh/.zprofile" ".zprofile"
command-exists zsh && symlink-to-home "./sh/.zshrc" ".zshrc"
command-exists git && symlink-to-home ".gitconfig" ".gitconfig"
command-exists git && symlink-to-home ".gitignore.global" ".gitignore"
command-exists nvim && symlink-to-home "nvim" ".config/nvim"
command-exists aerospace && symlink-to-home "aerospace.toml" ".config/aerospace/aerospace.toml"
command-exists alacritty && symlink-to-home "alacritty.toml" ".config/alacritty/alacritty.toml"
command-exists ghostty && symlink-to-home "ghostty" ".config/ghostty"
command-exists neovide && symlink-to-home "neovide.toml" ".config/neovide/config.toml"
command-exists starship && symlink-to-home "starship.toml" ".config/starship.toml"
command-exists zellij && symlink-to-home "zellij" ".config/zellij"

[ -d ~/.glzr/glazewm ] && symlink-to-home "glazewm.yaml" ".glzr/glazewm/config.yaml"
[ -d ~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState ] && symlink-to-home "windows-terminal/settings.json" "AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
