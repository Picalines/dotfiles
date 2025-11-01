local keymap = require 'util.keymap'

-- go to left tab when closing
vim.go.tabclose = 'left'

-- NOTE: <Tab> is same as <C-i> in a TUI
-- Please, don't make this commit again

keymap {
	[{ 'n', silent = true, desc = 'Page: %s' }] = {
		['<Leader>tn'] = { '<Cmd>tabnew<CR>', 'new' },
		['<Leader>td'] = { '<Cmd>tabclose<CR>', 'close' },

		[']t'] = { '<Cmd>tabnext<CR>', 'next' },
		['[t'] = { '<Cmd>tabprev<CR>', 'prev' },

		['<Leader>to'] = { '<Cmd>tabonly<CR>', 'only' },
	},
}
