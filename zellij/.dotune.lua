if not Path.which 'zellij' then
	return
end

local src = Path.here
local dst = OS.match {
	windows = Windows.roaming_app_data / 'Zellij/config',
	unix = XDG.config / 'zellij',
}

Dot.link((src / 'config.kdl'):to(dst))
Dot.link((src / 'layouts/default.kdl'):to(dst / 'layouts'))
