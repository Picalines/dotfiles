return {
	'folke/which-key.nvim',

	event = 'VeryLazy',
	cmd = 'WhichKey',

	init = function()
		local keymap = require 'util.keymap'

		keymap {
			[{ 'n' }] = {
				['<Leader>?'] = { '<Cmd>WhichKey<CR>', 'keymap help' },
			},
		}
	end,

	opts = {
		preset = 'helix',
		delay = 500,
	},
}
