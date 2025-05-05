local keymap = require 'util.keymap'
local autocmd = require 'util.autocmd'

keymap {
	[{ 'n', silent = true }] = {
		['<leader>q'] = { '<Cmd>copen<CR>', 'Open quickfix list' },

		[']q'] = { '<Cmd>cnext<CR>zz', 'Go to next quickfix item' },
		['[q'] = { '<Cmd>cprevious<CR>zz', 'Go to previous quickfix item' },

		[']Q'] = { '<Cmd>cnewer<CR>', 'Go to newer quickfix list' },
		['[Q'] = { '<Cmd>colder<CR>', 'Go to older quickfix list' },
	},
}

local augroup = autocmd.group 'quickfix'

augroup:on('FileType', 'qf', function(event)
	keymap {
		[{ 'n', remap = true, silent = true, buffer = event.buf }] = {
			['q'] = { '<Cmd>cclose<CR>', 'Close quickfix list' },
			['<leader>q'] = { '<Cmd>cclose<CR>', 'Close quickfix list' },

			['dd'] = { "<Cmd>call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r') <Bar> cc<CR>", 'Remove entry' },

			['<leader>r'] = { '<Cmd>cdo s/// | update<C-Left><C-Left><Left><Left><Left>', 'Begin substitution' },
		},
	}
end)
