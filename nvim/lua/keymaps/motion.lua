local util = require 'keymaps.util'

util.declare_keymaps {
	n = {
		['<C-u>'] = '<C-u>zz',
		['<C-d>'] = '<C-d>zz',

		['n'] = 'nzzzv',
		['N'] = 'Nzzzv',
	},
}
