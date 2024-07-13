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
		local util = require 'util'
		local twilight = require 'twilight'

		twilight.setup(opts)

		util.declare_keymaps {
			[{ 'n', silent = true }] = {
				['<leader>Z'] = { ':Twilight<CR>', 'Toggle [Z]en mode' },
			},
		}
	end,
}
