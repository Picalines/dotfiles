local app = require 'util.app'

app.switch {
	nvim = function()
		require 'settings.nvim'
	end,

	neovide = function()
		require 'settings.neovide'
	end,
}
