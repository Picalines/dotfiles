if not Path.which 'git' then
	return
end

local src = Path.here
Dot.link((src / '.gitconfig'):to(Path.home))
Dot.link(src / '.gitignore.global', Path.home / '.gitignore')

if Path.which 'lazygit' then
	Dot.link(src / 'lazygit.yml', XDG.config / 'lazygit/config.yml')
end
