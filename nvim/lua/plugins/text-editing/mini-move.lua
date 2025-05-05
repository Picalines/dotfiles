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

		local move_selection = mini_move.move_selection

		keymap {
			[{ 'x' }] = {
				['H'] = { func.curry(move_selection, 'left'), 'Move selection left' },
				['J'] = { func.curry(move_selection, 'down'), 'Move selection down' },
				['K'] = { func.curry(move_selection, 'up'), 'Move selection up' },
				['L'] = { func.curry(move_selection, 'right'), 'Move selection right' },
			},
		}
	end,
}
