if not (Path.which 'qutebrowser' or (Mac.applications / 'qutebrowser.app'):exists() or (Windows.roaming_app_data / 'qutebrowser'):exists()) then
	return
end

local src = Path.here
local dst = OS.match {
	windows = Windows.roaming_app_data / 'qutebrowser/config',
	unix = Path.home / '.qutebrowser',
}

Dot.link(src, dst)
