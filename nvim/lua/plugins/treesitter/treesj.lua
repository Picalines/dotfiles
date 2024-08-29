return {
	'Wansmer/treesj',

	dependencies = { 'nvim-treesitter/nvim-treesitter' },

	event = 'LspAttach',

	opts = {
		use_default_keymaps = false,
	},

	config = function(_, opts)
		local keymap = require 'util.keymap'
		local treesj = require 'treesj'

		treesj.setup(opts)

		keymap.declare {
			[{ 'n' }] = {
				['<leader>j'] = { treesj.toggle, 'Join Treesitter nodes' },
			},
		}
	end,
}
