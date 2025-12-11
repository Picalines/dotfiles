return {
	'nvim-treesitter/nvim-treesitter-context',

	event = 'VeryLazy',

	opts = {
		multiwindow = true,
		mode = 'topline',
	},

	init = function()
		local keymap = require 'util.keymap'

		keymap {
			[{ 'n', desc = 'UI: %s' }] = {
				['<Leader>oc'] = { '<Cmd>TSContext toggle<CR>', 'toggle TS context' },
			},
		}
	end,
}
