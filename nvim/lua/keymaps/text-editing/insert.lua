local keymap = require 'util.keymap'

keymap.declare {
	[{ 'i' }] = {
		['<C-j>'] = '<Down>',
		['<C-k>'] = '<Up>',
		['<C-l>'] = '<Right>',
		['<C-h>'] = '<Left>',

		['<C-b>'] = '<C-o>b',
		['<C-e>'] = '<Esc><Cmd>norm! e<CR>a',
		['<C-w>'] = '<C-o>w',

		['<C-p>'] = '<C-r>*',
	},
}
