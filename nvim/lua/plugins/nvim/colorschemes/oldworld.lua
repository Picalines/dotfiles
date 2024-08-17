return {
	'dgox16/oldworld.nvim',

	lazy = false,

	priority = 1000,

	config = function(_, opts)
		local hl = require 'util.highlight'

		require('oldworld').setup(opts)

		vim.api.nvim_create_autocmd('ColorScheme', {
			pattern = 'oldworld',
			callback = function()
				hl.link('NormalNC', 'Normal')
				hl.clear('TabLineFill', 'all')
			end,
		})
	end,
}
