return {
	'dgox16/oldworld.nvim',

	lazy = false,

	priority = 1000,

	config = function(_, opts)
		local autocmd = require 'util.autocmd'
		local hl = require 'util.highlight'

		require('oldworld').setup(opts)

		autocmd.on_colorscheme('oldworld', function()
			hl.link('NormalNC', 'Normal')
			hl.clear('TabLineFill', 'all')
		end)
	end,
}
