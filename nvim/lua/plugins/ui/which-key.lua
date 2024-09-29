return {
	'folke/which-key.nvim',

	event = 'UiEnter',

	opts = {},

	config = function(_, opts)
		local keymap = require 'util.keymap'

		require('which-key').setup(opts)

		keymap.declare {
			[{ 'n' }] = {
				['<leader>?'] = { '<Cmd>WhichKey<CR>', 'Keymap help' },
			},
		}
	end,
}
