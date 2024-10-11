local keymap = require 'util.keymap'
local func = require 'util.func'

local goto_next = vim.diagnostic.goto_next
local goto_prev = vim.diagnostic.goto_prev
local severity = vim.diagnostic.severity

keymap.declare {
	[{ 'n', 'v' }] = {
		['<Space>'] = '<Nop>',

		['<C-u>'] = '<C-u>zz',
		['<C-d>'] = '<C-d>zz',

		['n'] = 'nzzzv',
		['N'] = 'Nzzzv',

		-- col('.') == 1 || col('.') > match(getline('.'), '\\S') + 1 ? '^' : '0'
		['H'] = '^',
		['L'] = '$',

		[{ expr = true }] = {
			['k'] = "v:count == 0 ? 'gk' : 'k'",
			['j'] = "v:count == 0 ? 'gj' : 'j'",
		},
	},

	[{ 'n', silent = true }] = {
		-- nvim 0.11
		-- ['[d'] = { func.curry(vim.diagnostic.jump, { count = -1, float = false }), 'Go to previous diagnostic' },
		-- [']d'] = { func.curry(vim.diagnostic.jump, { count = 1, float = false }), 'Go to next diagnostic' },
		[']d'] = { func.curry(goto_next, { float = false }), 'Go to next diagnostic' },
		['[d'] = { func.curry(goto_prev, { float = false }), 'Go to previous diagnostic' },
		[']e'] = { func.curry(goto_next, { float = false, severity = severity.ERROR }), 'Go to next error' },
		['[e'] = { func.curry(goto_prev, { float = false, severity = severity.ERROR }), 'Go to previous error' },
		[']w'] = { func.curry(goto_next, { float = false, severity = severity.WARN }), 'Go to next warning' },
		['[w'] = { func.curry(goto_prev, { float = false, severity = severity.WARN }), 'Go to previous warning' },
	},
}
