source ~/.config/posix/profile.sh

if [[ ( "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ) && -f ~/.bashrc ]]; then
  source ~/.bashrc
fi

