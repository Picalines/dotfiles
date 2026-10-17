include 'posix'
include 'bash'
include 'zsh'
include 'pwsh'

Dot.link((Path.here / '.inputrc'):to(Path.home))

if Path.which 'starship' then
	Dot.link((Path.here / 'starship.toml'):to(XDG.config))
end
