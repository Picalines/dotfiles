local keymap = require 'util.keymap'

keymap.declare {
	[{ 't' }] = {
		['<Esc>'] = { [[<C-\><C-n>]], 'Exit terminal mode' },
		['<C-p>'] = { [[<C-\><C-n>pi]], 'Paste' },
	},
}
