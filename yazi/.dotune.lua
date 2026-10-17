if not (Path.which 'yazi' and OS.matches 'unix') then
	return
end

Dot.link(Path.here:to(XDG.config))
