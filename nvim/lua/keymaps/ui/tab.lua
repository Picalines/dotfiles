local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', silent = true, desc = 'Tab: %s' }] = {
		['<tab>n'] = { '<Cmd>tabnew<CR>', 'new' },
		['<tab>d'] = { '<Cmd>tabclose<CR>', 'close' },

		['<tab><tab>'] = { '<Cmd>tabnext<CR>', 'next' },
		['<tab><S-tab<'] = { '<Cmd>tabprev<CR>', 'prev' },
		['<tab>]'] = { '<Cmd>tabnext<CR>', 'next' },
		['<tab>['] = { '<Cmd>tabprev<CR>', 'prev' },

		['<tab>o'] = { '<Cmd>tabonly<CR>', 'only' },
	},
}
