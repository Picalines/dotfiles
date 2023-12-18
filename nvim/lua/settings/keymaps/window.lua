local util = require 'util'

util.declare_keymaps {
	opts = {
		silent = true,
	},

	n = {
		['<C-j>'] = { '<C-W>j', 'Move to bottom split' },
		['<C-k>'] = { '<C-W>k', 'Move to upper split' },
		['<C-h>'] = { '<C-W>h', 'Move to left split' },
		['<C-l>'] = { '<C-W>l', 'Move to right split' },
	},
}
