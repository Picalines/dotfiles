if not OS.matches 'windows' then
	return
end

local src = Path.here
local funny_dst = Windows.local_app_data / 'Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState'
if not funny_dst:exists() then
	return
end

Dot.link((src / 'settings.json'):to(funny_dst))
