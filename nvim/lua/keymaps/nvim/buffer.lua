local util = require 'util'

local function is_modified(buffer)
	return vim.api.nvim_get_option_value('modified', { buf = buffer })
end

local function close_buffer()
	local get_current_win = vim.api.nvim_get_current_win
	local get_current_buf = vim.api.nvim_get_current_buf

	local win = get_current_win()
	local buf = get_current_buf()

	if is_modified(0) then
		vim.cmd ':silent w'
	end

	vim.cmd ':bp'

	if win == get_current_win() and buf == get_current_buf() then
		vim.cmd ':enew'
	end

	vim.cmd ':silent! bd #'
end

local function close_all_buffers()
	vim.cmd [[
		:silent wa
		:silent bd *
	]]
end

util.declare_keymaps {
	opts = {
		silent = true,
	},
	n = {
		['<leader>s'] = { ':silent w<CR>', '[S]ave file' },

		['<C-b>e'] = { ':enew<CR>', '[E]empty [b]uffer' },
		['<C-b>c'] = { close_buffer, '[C]lose [b]uffer' },
		['<C-b>C'] = { close_all_buffers, '[C]lose all [b]uffers' },
		[']b'] = { ':bn<CR>', 'Next [b]uffer' },
		['[b'] = { ':bp<CR>', 'Prev [b]uffer' },
	},
}
