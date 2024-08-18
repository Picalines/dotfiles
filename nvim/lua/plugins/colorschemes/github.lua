return {
	'projekt0n/github-nvim-theme',

	lazy = false,

	priority = 1000,

	config = function()
		local autocmd = require 'util.autocmd'
		local hl = require 'util.highlight'

		require('github-theme').setup {}

		autocmd.on_colorscheme('github_*', function()
			hl.link('NormalFloat', 'Normal')
			hl.link('NormalSB', 'Normal')
		end)
	end,
}
