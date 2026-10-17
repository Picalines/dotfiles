local src = Path.here
local dst = Path.home / 'bin'

Dot.link((src / 'keyboard-layout'):to(dst))
