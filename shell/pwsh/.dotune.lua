if not OS.matches 'windows' then
	return
end

local src = Path.here
local dst = Windows.documents / 'PowerShell'
if not dst:exists() then
	return
end

Dot.link(src / 'profile.ps1', dst / 'Microsoft.PowerShell_profile.ps1')
