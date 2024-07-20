local keymap = require 'util.keymap'
local func = require 'util.func'

keymap.declare {
	[{ 'n', 'v', silent = true, expr = true }] = {
		['k'] = "v:count == 0 ? 'gk' : 'k'",
		['j'] = "v:count == 0 ? 'gj' : 'j'",
	},
}

keymap.declare {
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
		['[d'] = { func.curry(vim.diagnostic.jump, { count = -1, float = false }), 'Go to previous [d]iagnostic' },
		[']d'] = { func.curry(vim.diagnostic.jump, { count = 1, float = false }), 'Go to next [d]iagnostic' },
	},
}
