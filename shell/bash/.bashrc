shopt -s nullglob
for f in ~/.config/bash/rc.d/*.bash; do
  source "$f"
done
shopt -u nullglob
