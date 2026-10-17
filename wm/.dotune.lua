local src = Path.here

if OS.matches 'macos' and Path.which 'aerospace' then
	Dot.link((src / 'aerospace.toml'):to(XDG.config / 'aerospace'))
end

local glazewm = Path.home / '.glzr/glazewm'
if OS.matches 'windows' and glazewm:exists() then
	Dot.link(src / 'glazewm.yaml', glazewm / 'config.yaml')
end
