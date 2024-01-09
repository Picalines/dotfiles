local util = require 'util'

util.switch_app {
	nvim = function()
		require 'keymaps.nvim'
	end,

	neovide = function()
		require 'keymaps.neovide'
	end,

	vscode = function()
		require 'keymaps.vscode'
	end,
}
