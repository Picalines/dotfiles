local keymap = require 'util.keymap'
local func = require 'util.func'

keymap.declare {
	[{ 'n', 'v', silent = true, expr = true }] = {
		['k'] = "v:count == 0 ? 'gk' : 'k'",
		['j'] = "v:count == 0 ? 'gj' : 'j'",
	},
}

keymap.declare {
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

	[{ 'n', silent = true }] = {
		['[d'] = { func.curry(vim.diagnostic.jump, { count = -1, float = false }), 'Go to previous diagnostic' },
		[']d'] = { func.curry(vim.diagnostic.jump, { count = 1, float = false }), 'Go to next diagnostic' },
	},
}
