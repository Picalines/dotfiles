local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', nowait = true }] = {
		[{ os = 'macos' }] = {
			['<D-w>'] = { '<Cmd>wa | qa!<CR>', 'Neovide: Write all and quit' },
			['<D-n>'] = { '<Cmd>silent !open --new -b com.neovide.neovide<CR>', 'Neovide: New Window' },
		},
	},
}
