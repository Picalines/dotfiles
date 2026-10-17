if not Path.which 'nvim' then
	return
end

Dot.link(Path.here, XDG.config / 'nvim')

if Path.which 'neovide' then
	Dot.link(Path.here / 'neovide.toml', XDG.config / 'neovide/config.toml')
end
