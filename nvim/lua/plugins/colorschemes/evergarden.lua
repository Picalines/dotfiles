return {
	'crispybaccoon/evergarden',

	lazy = false,

	priority = 1000,

	opts = {
		transparent_background = false,

		contrast_dark = 'hard',

		override_terminal = true,

		style = {
			tabline = { reverse = true, color = 'green' },
			search = { reverse = false, inc_reverse = true },
			types = { italic = true },
			keyword = { italic = true },
			comment = { italic = true },
			sign = {},
		},

		overrides = {},
	},

	config = function(_, opts)
		local autocmd = require 'util.autocmd'
		local hl = require 'util.highlight'

		require('evergarden').setup(opts)

		autocmd.on('ColorScheme', 'evergarden', function()
			vim.cmd 'hi NoiceCursor gui=inverse'
			vim.o.background = 'dark'
			hl.link('NormalFloat', 'Normal')
		end)
	end,
}
