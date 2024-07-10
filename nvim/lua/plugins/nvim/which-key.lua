return {
	'folke/which-key.nvim',

	opts = {},

	config = function(_, opts)
		local util = require 'util'

		require('which-key').setup(opts)

		util.declare_keymaps {
			n = {
				['<leader>?'] = { ':WhichKey<CR>', 'Keymap help' },
			},
		}
	end,
}
