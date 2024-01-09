return {
	'Wansmer/treesj',

	dependencies = { 'nvim-treesitter/nvim-treesitter' },

	keys = { 'cm' },

	config = function()
		local treesj = require 'treesj'

		treesj.setup {
			use_default_keymaps = false,
		}

		require('util').declare_keymaps {
			n = {
				['cm'] = { treesj.toggle, 'Split/Join node' },
			},
		}
	end,
}
