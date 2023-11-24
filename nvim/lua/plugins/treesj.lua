return {
	'Wansmer/treesj',

	dependencies = { 'nvim-treesitter/nvim-treesitter' },

	keys = { '<leader>m' },

	config = function()
		local treesj = require 'treesj'

		treesj.setup {
			use_default_keymaps = false,
		}

		require('keymaps.util').declare_keymaps {
			n = {
				['<leader>m'] = { treesj.toggle, 'Split/Join node' },
			},
		}
	end,
}
