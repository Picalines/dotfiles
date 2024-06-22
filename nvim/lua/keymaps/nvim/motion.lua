local util = require 'util'

util.declare_keymaps {
	[{ 'n', 'v', silent = true, expr = true }] = {
		['k'] = "v:count == 0 ? 'gk' : 'k'",
		['j'] = "v:count == 0 ? 'gj' : 'j'",
	},
}

util.declare_keymaps {
	opts = {
		silent = true,
	},

	[{ 'n', 'v' }] = {
		['<Space>'] = '<Nop>',

		['<C-u>'] = '<C-u>zz',
		['<C-d>'] = '<C-d>zz',

		['n'] = 'nzzzv',
		['N'] = 'Nzzzv',

		['gh'] = '^',
		['gH'] = '0',
		['gl'] = '$',
	},

	i = {
		['<C-j>'] = '<Down>',
		['<C-k>'] = '<Up>',
		['<C-l>'] = '<Right>',
		['<C-h>'] = '<Left>',

		['<C-b>'] = '<C-o>b',
		['<C-e>'] = '<Left><C-o>e<Right>',
		['<C-w>'] = '<C-o>w',
	},

	n = {
		['[d'] = { vim.diagnostic.goto_prev, 'Go to previous [d]iagnostic' },
		[']d'] = { vim.diagnostic.goto_next, 'Go to next [d]iagnostic' },
	},
}
