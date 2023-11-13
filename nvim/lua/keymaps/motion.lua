local util = require 'keymaps.util'

util.declare_keymaps {
	[{ 'n', 'v' }] = {
		['<C-u>'] = '<C-u>zz',
		['<C-d>'] = '<C-d>zz',

		['n'] = 'nzzzv',
		['N'] = 'Nzzzv',

		['gh'] = '^',
		['gH'] = '0',
		['gl'] = '$',
	},
}
