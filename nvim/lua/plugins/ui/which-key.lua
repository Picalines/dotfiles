return {
	'folke/which-key.nvim',

	event = 'VeryLazy',

	opts = { preset = 'modern' },

	config = function(_, opts)
		local keymap = require 'util.keymap'

		require('which-key').setup(opts)

		keymap {
			[{ 'n' }] = {
				['<leader>?'] = { '<Cmd>WhichKey<CR>', 'Keymap help' },
			},
		}
	end,
}
