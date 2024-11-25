local lazy = require 'lazy'
local app = require 'util.app'
local array = require 'util.array'

local client = app.client()

local client_modules = {
	terminal = {
		'colorschemes',
		'lang-service',
		'text-editing',
		'treesitter',
		'ui',
	},
	neovide = {},
	vscode = {
		'text-editing',
		'treesitter',
	},
}

local lazy_modules

if client == 'vscode' then
	lazy_modules = client_modules.vscode
else
	lazy_modules = client_modules.terminal

	if client == 'neovide' then
		lazy_modules = array.concat(lazy_modules, client_modules.neovide)
	end
end

local lazy_spec = array.map(lazy_modules, function(module)
	return { import = 'plugins.' .. module }
end)

lazy.setup(lazy_spec, {
	performance = {
		rtp = {
			disabled_plugins = {
				'gzip',
				-- 'matchit',
				-- 'matchparen',
				'netrwPlugin',
				'tarPlugin',
				'tohtml',
				'tutor',
				'zipPlugin',
			},
		},
	},
})
