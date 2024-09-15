ln -snf $PWD/.bashrc ~/.bashrc
ln -snf $PWD/.zshrc ~/.zshrc

mkdir -p ~/.config

ln -snf $PWD/nvim ~/.config/nvim

if command -v aerospace &> /dev/null
then
    mkdir -p ~/.config/aerospace
    ln -snf $PWD/aerospace.toml ~/.config/aerospace/aerospace.toml
fi

if command -v starship &> /dev/null
then
    ln -snf $PWD/starship.toml ~/.config/starship.toml
fi

if command -v alacritty &> /dev/null
then
    mkdir -p ~/.config/alacritty
    ln -snf $PWD/alacritty.toml ~/.config/alacritty/alacritty.toml
fi
