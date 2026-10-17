if not Path.which 'bash' then
	return
end

local src = Path.here
local dst = Path.home
Dot.link((src / '.bash_profile'):to(dst))
Dot.link((src / '.bashrc'):to(dst))
