local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', silent = true, desc = 'Buffer: %s' }] = {
		['<C-b>n'] = { '<Cmd>enew<CR>', 'new' },
		['<C-b>r'] = { '<Cmd>e<CR>', 'reload' },
		['<C-b>c'] = { '<Cmd>exe "silent w" | bd<CR>', 'close' },
		['<C-b>C'] = { '<Cmd>bd!<CR>', 'close without saving' },
		[']b'] = { '<Cmd>bn<CR>', 'next' },
		['[b'] = { '<Cmd>bp<CR>', 'previous' },
	},
}
