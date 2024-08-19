local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', 'x' }] = {
		['<leader>v'] = { '"_', 'Void register' },
	},
}
