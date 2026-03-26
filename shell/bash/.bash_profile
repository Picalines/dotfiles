shopt -s nullglob
for f in ~/.config/bash/profile.d/*.bash; do
  source "$f"
done
shopt -u nullglob
