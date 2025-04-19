ln -snf $PWD/.bashrc ~/.bashrc
ln -snf $PWD/.zshrc ~/.zshrc

mkdir -p ~/.config

if command -v nvim &> /dev/null
then
    ln -snf $PWD/nvim ~/.config/nvim
fi

if command -v aerospace &> /dev/null
then
    mkdir -p ~/.config/aerospace
    ln -snf $PWD/aerospace.toml ~/.config/aerospace/aerospace.toml
fi

if command -v alacritty &> /dev/null
then
    mkdir -p ~/.config/alacritty
    ln -snf $PWD/alacritty.toml ~/.config/alacritty/alacritty.toml
fi

if command -v ghostty &> /dev/null
then
    mkdir -p ~/.config/ghostty
    ln -snf $PWD/ghostty.config ~/.config/ghostty/config
fi

if command -v neovide &> /dev/null
then
    mkdir -p ~/.config/neovide
    ln -snf $PWD/neovide.toml ~/.config/neovide/config.toml
fi

if command -v starship &> /dev/null
then
    ln -snf $PWD/starship.toml ~/.config/starship.toml
fi
