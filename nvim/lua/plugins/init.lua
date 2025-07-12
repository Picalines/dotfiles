local app = require 'util.app'
local lazy = require 'lazy'

local client = app.client()

local client_modules = {
	terminal = {
		'colorschemes',
		'lang-service',
		'text-editing',
		'ui',
	},
	neovide = {
		'colorschemes',
		'lang-service',
		'text-editing',
		'ui',
	},
	vscode = {
		'text-editing',
		'lang-service',
	},
}

local lazy_spec = vim
	.iter(client_modules[client])
	:map(function(module)
		return { import = 'plugins.' .. module }
	end)
	:totable()

lazy.setup(lazy_spec, {
	lockfile = vim.fn.stdpath 'config' .. '/lazy-lock.json',
	change_detection = {
		enabled = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				'gzip',
				-- 'matchit',
				-- 'matchparen',
				-- 'netrwPlugin',
				'tarPlugin',
				'tohtml',
				'tutor',
				'zipPlugin',
			},
		},
	},
})
