return {
	'folke/twilight.nvim',

	event = 'VeryLazy',

	opts = {
		expand = {
			'function',
			'method',
			'table',
			'if_statement',
		},
	},

	config = function(_, opts)
		local keymap = require 'util.keymap'
		local twilight = require 'twilight'

		twilight.setup(opts)

		keymap.declare {
			[{ 'n', silent = true }] = {
				['<leader>Z'] = { ':Twilight<CR>', 'Toggle [Z]en mode' },
			},
		}
	end,
}
