local func = require 'util.func'
local keymap = require 'util.keymap'

keymap {
	[{ 'n' }] = {
		['u'] = { '<Cmd>undo<CR>', 'undo' },
		['U'] = { '<Cmd>redo<CR>', 'redo' },

		['<leader>w'] = { '<Cmd>silent w<CR>', 'Write file' },
		['<leader>W'] = { '<Cmd>silent wa!<CR>', 'Write all' },

		['g/'] = { ':%s###g<Left><Left><Left>', 'Substitute' },

		[{ silent = true }] = {
			['[d'] = { func.curry(vim.diagnostic.jump, { count = -1, float = false }), 'previous diagnostic' },
			[']d'] = { func.curry(vim.diagnostic.jump, { count = 1, float = false }), 'next diagnostic' },
		},

		['y<C-g>'] = { '<Cmd>eval setreg(v:register, @%) | echo @% . " -> " . v:register<CR>', 'yank buffer path' },
	},

	[{ 'i', 'c' }] = {
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

	[{ 'x' }] = {
		['p'] = '"_dP',
		['g/'] = { ':s###g<Left><Left><Left>', 'Substitute' },
	},

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

		['<C-x>'] = { '"_', 'Void register' },

		['g:'] = { ':g##<Left>', 'Global command' },
	},

	[{ 't' }] = {
		['<C-p>'] = { '<C-\\><C-n>pi', 'paste' },
	},
}
