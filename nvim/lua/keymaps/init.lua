local app = require 'util.app'

app.switch {
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
