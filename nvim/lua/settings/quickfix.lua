local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

keymap {
	[{ 'n', silent = true, desc = 'Quickfix: %s' }] = {
		['<Leader>q'] = { ':botright copen | resize <C-r>=&lines / 3<CR><CR>', 'open' },
	},
}

local augroup = autocmd.group 'quickfix'

vim.g.quickfix_scroll = function()
	local qf_info = vim.fn.getqflist { idx = 0, size = 0 }
	return string.format('%s/%s', qf_info.idx, qf_info.size)
end

augroup:on('FileType', 'qf', function(event)
	local wo = vim.wo[vim.fn.bufwinid(event.buf)]

	wo.winbar = ' quickfix %{g:quickfix_scroll()}'

	keymap {
		[{ 'n', remap = true, silent = true, buffer = event.buf, desc = 'Quickfix: %s' }] = {
			['q'] = { '<Cmd>cclose<CR>', 'close' },
			['<Leader>q'] = { '<Cmd>cclose<CR>', 'close' },
		},
	}
end)
