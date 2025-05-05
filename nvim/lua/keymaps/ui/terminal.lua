local keymap = require 'util.keymap'

keymap {
	[{ 't' }] = {
		['<Esc>'] = { [[<C-\><C-n>]], 'Exit terminal mode' },
		['<C-p>'] = { [[<C-\><C-n>pi]], 'Paste' },
	},
}
