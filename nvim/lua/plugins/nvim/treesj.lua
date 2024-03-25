return {
	'Wansmer/treesj',

	dependencies = { 'nvim-treesitter/nvim-treesitter' },

	event = 'LspAttach',

	opts = {
		use_default_keymaps = false,
	},

	config = function(_, opts)
		local treesj = require 'treesj'
		local util = require 'util'

		treesj.setup(opts)

		util.declare_keymaps {
			n = {
				['cI'] = { treesj.toggle, 'Change indentation' },
			},
		}
	end,
}
