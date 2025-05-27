local keymap = require 'util.keymap'

keymap {
	[{ 'i' }] = {
		['<C-l>'] = '<Right>',
		['<C-h>'] = '<Left>',

		['<C-b>'] = '<C-o>b',
		['<C-e>'] = '<Esc><Cmd>norm! e<CR>a',
		['<C-w>'] = '<C-o>w',

		['<S-BS>'] = '<Delete>',
		['<M-BS>'] = '<Delete>',
	},

	[{ 'i', 'c' }] = {
		['<C-p>'] = { '<C-r>*', 'paste' },
	},

	[{ 't' }] = {
		['<C-p>'] = { '<C-\\><C-n>pi', 'paste' },
	},
}
