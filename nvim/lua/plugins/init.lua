local lazy = require 'lazy'
local util = require 'util'

util.switch_app {
	nvim = function()
		lazy.setup {
			{ import = 'plugins.nvim' },
			{ import = 'plugins.nvim.colorschemes' },
		}
	end,

	vscode = function()
		lazy.setup {
			{ import = 'plugins.vscode' },
		}
	end,
}
