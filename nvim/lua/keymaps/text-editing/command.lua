local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n' }] = {
		['<leader>w'] = { '<Cmd>silent w<CR>', 'Write file' },
		['<leader>W'] = { '<Cmd>silent wa!<CR>', 'Write all' },
		['<leader><leader>q'] = { '<Cmd>wa | qa!<CR>', 'Write all and quit' },

		['<leader>s'] = { ':%s/', 'Substitute' },
	},

	[{ 'v' }] = {
		['<leader>s'] = { ':s/', 'Substitute' },

		['<leader>o'] = { ':sort<CR>', 'Sort' },
		['<leader>O'] = { ':sort!<CR>', 'Sort (reversed)' },
	},
}
