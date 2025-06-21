local keymap = require 'util.keymap'

keymap {
	[{ 'n' }] = {
		['<leader>?'] = { '<Cmd>WhichKey<CR>', 'keymap help' },
	},
}

return {
	'folke/which-key.nvim',

	event = 'VeryLazy',
	cmd = 'WhichKey',

	opts = {
		preset = 'helix',
		delay = 500,
	},
}
