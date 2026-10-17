if not Path.which 'mise' then
	return
end

Dot.link(Path.here / 'mise.toml', XDG.config / 'mise/config.toml')
