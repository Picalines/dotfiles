local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n' }] = {
		['<leader>w'] = { '<Cmd>silent w<CR>', 'Write file' },
		['<leader>W'] = { '<Cmd>silent wa!<CR>', 'Write all' },

		['<leader>s'] = { ':%s//g<Left><Left>', 'Substitute' },
		['<leader>g'] = { ':%g/', 'Global command' },
	},

	[{ 'x' }] = {
		['<leader>s'] = { ':s//g<Left><Left>', 'Substitute' },
		['<leader>g'] = { ':g/', 'Global command' },

		['<leader>o'] = { ':sort<CR>', 'Sort' },
		['<leader>O'] = { ':sort!<CR>', 'Sort (reversed)' },

		['p'] = '"_dP',
	},

	[{ 'n', 'v' }] = {
		['<leader>x'] = { '"_', 'Void register' },
	},
}
