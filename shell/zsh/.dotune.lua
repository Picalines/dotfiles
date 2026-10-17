if not Path.which 'zsh' then
	return
end

local src = Path.here
local dst = Path.home
Dot.link((src / '.zprofile'):to(dst))
Dot.link((src / '.zshrc'):to(dst))
