local keymap = require 'util.keymap'

keymap {
	[{ 'n' }] = {
		['u'] = { '<Cmd>undo<CR>', 'undo' },
		['U'] = { '<Cmd>redo<CR>', 'redo' },

		['<leader>w'] = { '<Cmd>silent w<CR>', 'Write file' },
		['<leader>W'] = { '<Cmd>silent wa!<CR>', 'Write all' },

		['g/'] = { ':%s//g<Left><Left>', 'Substitute' },
		['g:'] = { ':%g/', 'Global command' },
	},

	[{ 'x' }] = {
		['g/'] = { ':s//g<Left><Left>', 'Substitute' },
		['g:'] = { ':g/', 'Global command' },

		['p'] = '"_dP',
	},

	[{ 'n', 'x' }] = {
		['<leader>x'] = { '"_', 'Void register' },
	},
}
