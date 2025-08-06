return {
	'folke/which-key.nvim',

	event = 'VeryLazy',
	cmd = 'WhichKey',

	init = function()
		local keymap = require 'util.keymap'

		keymap {
			[{ 'n' }] = {
				['<leader>?'] = { '<Cmd>WhichKey<CR>', 'keymap help' },
			},
		}
	end,

	opts = {
		preset = 'helix',
		delay = 500,
	},
}
