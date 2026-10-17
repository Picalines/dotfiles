if not (Path.which 'ghostty' and OS.matches 'macos') then
	return
end

Dot.link(Path.here:to(XDG.config))
