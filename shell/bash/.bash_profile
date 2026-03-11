export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

if [[ "$OSTYPE" == "msys" && -f ~/.bashrc ]]; then
    source ~/.bashrc
fi
