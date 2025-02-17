local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n' }] = {
		['<leader>w'] = { '<Cmd>silent w<CR>', 'Write file' },
		['<leader>W'] = { '<Cmd>silent wa!<CR>', 'Write all' },

		['g/'] = { ':%s//g<Left><Left>', 'Substitute' },
		['g:'] = { ':%g/', 'Global command' },

		['g<CR>'] = { ':lua vim.ui.open([[<C-r>=expand("<cfile>")<CR>]])<CR>', 'Open in system app' },
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
