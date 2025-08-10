local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

keymap {
	[{ 'n', silent = true, desc = 'Quickfix: %s' }] = {
		['<leader>q'] = {
			expr = true,
			desc = 'open',
			function()
				return string.format('<Cmd>botright copen | resize %d<CR>', math.floor(vim.go.lines / 3))
			end,
		},

		[']q'] = { '<Cmd>cnext<CR>zz', 'next item' },
		['[q'] = { '<Cmd>cprevious<CR>zz', 'prev item' },

		[']Q'] = { '<Cmd>cnewer<CR>', 'newer list' },
		['[Q'] = { '<Cmd>colder<CR>', 'older list' },
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
			['<leader>q'] = { '<Cmd>cclose<CR>', 'close' },
		},
	}
end)
