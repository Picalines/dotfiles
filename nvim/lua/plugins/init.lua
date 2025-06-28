local app = require 'util.app'
local array = require 'util.array'
local lazy = require 'lazy'
local str = require 'util.string'

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

local lazy_spec = array.map(client_modules[client], function(module)
	return { import = 'plugins.' .. module }
end)

lazy.setup(lazy_spec, {
	lockfile = str.fmt(vim.fn.stdpath 'config', '/lazy-lock.json'),
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
