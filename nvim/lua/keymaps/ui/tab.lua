local keymap = require 'util.keymap'

-- NOTE: <Tab> is same as <C-i> in a TUI
-- Please, don't make this commit again

keymap.declare {
	[{ 'n', silent = true, desc = 'Space: %s' }] = {
		['<leader>sn'] = { '<Cmd>tabnew<CR>', 'new' },
		['<leader>sd'] = { '<Cmd>tabclose<CR>', 'close' },

		['<leader>ss'] = { '<Cmd>tabnext<CR>', 'next' },
		['<leader>s]'] = { '<Cmd>tabnext<CR>', 'next' },
		['<leader>s['] = { '<Cmd>tabprev<CR>', 'prev' },

		['<leader>so'] = { '<Cmd>tabonly<CR>', 'only' },
	},
}
