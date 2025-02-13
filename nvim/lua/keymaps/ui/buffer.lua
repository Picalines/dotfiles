local array = require 'util.array'
local keymap = require 'util.keymap'

local function number_of_buffers()
	return #array.filter(vim.api.nvim_list_bufs(), function(bufnr)
		return vim.api.nvim_get_option_value('buflisted', { buf = bufnr })
	end)
end

local function add_safe_empty_buffer()
	return number_of_buffers() <= 1 and '<Cmd>enew | b #<CR>' or ''
end

keymap.declare {
	[{ 'n', silent = true, desc = 'Buffer: %s' }] = {
		['<C-b>n'] = { '<Cmd>enew<CR>', 'new' },
		['<C-b>r'] = { '<Cmd>e<CR>', 'reload' },
		[']b'] = { '<Cmd>bn<CR>', 'next' },
		['[b'] = { '<Cmd>bp<CR>', 'previous' },

		['<C-b>c'] = {
			desc = 'close',
			expr = true,
			function()
				return add_safe_empty_buffer() .. '<Cmd>silent w!<CR><Cmd>bnext | bd #<CR>'
			end,
		},

		['<C-b>C'] = {
			desc = 'close without saving',
			expr = true,
			function()
				return add_safe_empty_buffer() .. '<Cmd>bprev | bd! #<CR>'
			end,
		},
	},
}
