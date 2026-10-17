if not Path.which 'alacritty' then
	return
end

local src = Path.here
local dst = OS.match {
	windows = Windows.roaming_app_data / 'alacritty',
	unix = XDG.config / 'alacritty',
}

local cfg_file = 'alacritty.toml'

Dot.link((src / cfg_file):to(dst))
Dot.link((src / cfg_file * 'common.toml'):to(dst))

if OS.matches 'windows' then
	Dot.link((src / cfg_file * 'windows.toml'):to(dst))
end
