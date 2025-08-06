local keymap = require 'util.keymap'

-- NOTE: <Tab> is same as <C-i> in a TUI
-- Please, don't make this commit again

keymap {
	[{ 'n', silent = true, desc = 'Page: %s' }] = {
		['<leader>pn'] = { '<Cmd>tabnew<CR>', 'new' },
		['<leader>pd'] = { '<Cmd>tabclose<CR>', 'close' },

		[']p'] = { '<Cmd>tabnext<CR>', 'next' },
		['[p'] = { '<Cmd>tabprev<CR>', 'prev' },
		['<leader>p]'] = { '<Cmd>tabnext<CR>', 'next' },
		['<leader>p['] = { '<Cmd>tabprev<CR>', 'prev' },

		['<leader>po'] = { '<Cmd>tabonly<CR>', 'only' },
	},
}
