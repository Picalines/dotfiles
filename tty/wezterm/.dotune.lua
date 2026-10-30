if not Path.which 'wezterm' then
	return
end

Dot.link(Path.here, XDG.config / 'wezterm')
