local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

keymap {
	[{ 'n', silent = true, desc = 'Quickfix: %s' }] = {
		['<leader>q'] = { '<Cmd>copen<CR>', 'open' },

		[']q'] = { '<Cmd>cnext<CR>zz', 'next item' },
		['[q'] = { '<Cmd>cprevious<CR>zz', 'prev item' },

		[']Q'] = { '<Cmd>cnewer<CR>', 'newer list' },
		['[Q'] = { '<Cmd>colder<CR>', 'older list' },
	},
}

local augroup = autocmd.group 'quickfix'

augroup:on('FileType', 'qf', function(event)
	keymap {
		[{ 'n', remap = true, silent = true, buffer = event.buf, desc = 'Quickfix: %s' }] = {
			['q'] = { '<Cmd>cclose<CR>', 'close' },
			['<leader>q'] = { '<Cmd>cclose<CR>', 'close' },
		},
	}
end)
