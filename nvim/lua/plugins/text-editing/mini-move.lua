return {
	'echasnovski/mini.move',

	event = 'VeryLazy',

	opts = {
		mappings = {
			left = 'H',
			right = 'L',
			down = 'J',
			up = 'K',

			line_left = '',
			line_right = '',
			line_down = '',
			line_up = '',
		},

		options = {
			reindent_linewise = true,
		},
	},

	config = function(_, opts)
		local mini_move = require 'mini.move'

		mini_move.setup(opts)
	end,
}
