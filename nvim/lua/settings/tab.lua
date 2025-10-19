local keymap = require 'util.keymap'

-- go to left tab when closing
vim.go.tabclose = 'left'

-- NOTE: <Tab> is same as <C-i> in a TUI
-- Please, don't make this commit again

keymap {
	[{ 'n', silent = true, desc = 'Page: %s' }] = {
		['<Leader>pn'] = { '<Cmd>tabnew<CR>', 'new' },
		['<Leader>pd'] = { '<Cmd>tabclose<CR>', 'close' },

		[']p'] = { '<Cmd>tabnext<CR>', 'next' },
		['[p'] = { '<Cmd>tabprev<CR>', 'prev' },
		['<Leader>p]'] = { '<Cmd>tabnext<CR>', 'next' },
		['<Leader>p['] = { '<Cmd>tabprev<CR>', 'prev' },

		['<Leader>po'] = { '<Cmd>tabonly<CR>', 'only' },
	},
}
