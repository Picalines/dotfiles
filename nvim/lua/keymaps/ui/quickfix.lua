local keymap = require 'util.keymap'
local autocmd = require 'util.autocmd'

keymap.declare {
	[{ 'n', silent = true }] = {
		[']q'] = { '<Cmd>cnext<CR>zz', 'Go to next quickfix item' },
		['[q'] = { '<Cmd>cprevious<CR>zz', 'Go to previous quickfix item' },
		['<leader>q'] = { '<Cmd>copen<CR>', 'Open quickfix list' },
	},
}

autocmd.per_filetype('qf', function(event)
	vim.bo[event.buf].modifiable = true

	keymap.declare {
		[{ 'n', remap = true, silent = true, buffer = event.buf }] = {
			['q'] = { '<Cmd>cclose<CR>', 'Close quickfix list' },
			['<leader>q'] = { '<Cmd>cclose<CR>', 'Close quickfix list' },
			['n'] = { '<Cmd>cnewer<CR>', 'Go to newer quickfix list' },
			['p'] = { '<Cmd>colder<CR>', 'Go to older quickfix list' },

			['J'] = '<Cmd>cnext<CR>zz<C-w>w',
			['K'] = '<Cmd>cprev<CR>zz<C-w>w',

			['<leader>r'] = { '<Cmd>cdo s/// | update<C-Left><C-Left><Left><Left><Left>', 'Begin substitution' },
		},
	}
end)
