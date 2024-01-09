local util = require 'util'

util.switch_app {
	nvim = function()
		require 'settings.keymaps.nvim'
	end,

	neovide = function()
		require 'settings.keymaps.neovide'
	end,

	vscode = function()
		require 'settings.keymaps.vscode'
	end,
}
