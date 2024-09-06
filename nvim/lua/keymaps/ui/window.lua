local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', silent = true }] = {
		['<C-j>'] = { '<C-W>j', 'Move to bottom window' },
		['<C-k>'] = { '<C-W>k', 'Move to upper window' },
		['<C-h>'] = { '<C-W>h', 'Move to left window' },
		['<C-l>'] = { '<C-W>l', 'Move to right window' },

		['<S-Down>'] = { '5<C-W>-', 'Decrease window height' },
		['<S-Up>'] = { '5<C-W>+', 'Increase window height' },
		['<S-Left>'] = { '5<C-W><', 'Decrease window width' },
		['<S-Right>'] = { '5<C-W>>', 'Increase window width' },

		['<leader><leader>nd'] = { '<Cmd>NoiceDismiss<CR>', 'Dismiss notifications' },
		['<Esc>'] = { '<Cmd>NoiceDismiss<CR>', 'Dismiss notifications' },
		['<leader><leader>nf'] = { '<Cmd>NoicePick<CR>', 'Find notification' },
	},
}
