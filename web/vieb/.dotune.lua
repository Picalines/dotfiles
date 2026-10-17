if not ((Mac.applications / 'Vieb.app'):exists() or (Windows.roaming_app_data / 'Vieb'):exists()) then
	return
end

local src = Path.here
local dst = Path.home
Dot.link((src / '.viebrc'):to(dst))
Dot.link((src / 'colors'):to(dst / '.vieb'))
