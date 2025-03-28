local keymap = require 'util.keymap'
local func = require 'util.func'

local severity = vim.diagnostic.severity

keymap.declare {
	[{ 'n', 'x' }] = {
		['<Space>'] = '<Nop>',

		['<C-u>'] = '<C-u>zz',
		['<C-d>'] = '<C-d>zz',

		['n'] = 'nzzzv',
		['N'] = 'Nzzzv',

		[{ expr = true }] = {
			['k'] = "v:count == 0 ? 'gk' : 'k'",
			['j'] = "v:count == 0 ? 'gj' : 'j'",
		},
	},

	[{ 'n', silent = true }] = {
		['[d'] = { func.curry(vim.diagnostic.jump, { count = -1, float = false }), 'Go to previous diagnostic' },
		[']d'] = { func.curry(vim.diagnostic.jump, { count = 1, float = false }), 'Go to next diagnostic' },
		['[e'] = { func.curry(vim.diagnostic.jump, { count = -1, float = false, severity = severity.ERROR }), 'Go to previous error' },
		[']e'] = { func.curry(vim.diagnostic.jump, { count = 1, float = false, severity = severity.ERROR }), 'Go to next error' },
		['[w'] = { func.curry(vim.diagnostic.jump, { count = -1, float = false, severity = severity.WARN }), 'Go to previous warning' },
		[']w'] = { func.curry(vim.diagnostic.jump, { count = 1, float = false, severity = severity.WARN }), 'Go to next warning' },
	},
}
