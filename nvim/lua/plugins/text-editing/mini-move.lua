return {
	'echasnovski/mini.move',

	event = 'VeryLazy',

	opts = {
		mappings = {},

		options = {
			reindent_linewise = true,
		},
	},

	config = function(_, opts)
		local keymap = require 'util.keymap'
		local mini_move = require 'mini.move'
		local func = require 'util.func'

		mini_move.setup(opts)

		local move_line = mini_move.move_line
		local move_selection = mini_move.move_selection

		keymap.declare {
			[{ 'n' }] = {
				['<C-S-h>'] = { func.curry(move_line, 'left'), 'Unindent line' },
				['<C-S-j>'] = { func.curry(move_line, 'down'), 'Move line down' },
				['<C-S-k>'] = { func.curry(move_line, 'up'), 'Move line up' },
				['<C-S-l>'] = { func.curry(move_line, 'right'), 'Indent line' },
			},

			[{ 'v' }] = {
				['<C-S-h>'] = { func.curry(move_selection, 'left'), 'Move selection left' },
				['<C-S-j>'] = { func.curry(move_selection, 'down'), 'Move selection down' },
				['<C-S-k>'] = { func.curry(move_selection, 'up'), 'Move selection up' },
				['<C-S-l>'] = { func.curry(move_selection, 'right'), 'Move selection right' },
			},
		}
	end,
}
