local util = require 'util'

util.switch_app {
	nvim = function()
		require 'settings.nvim'
	end,

	neovide = function()
		require 'settings.neovide'
	end,
}
