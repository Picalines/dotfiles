local keymap = require 'util.keymap'

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
		:silent wa!
		:silent! %bd
		:Neotree filesystem current reveal_force_cwd
		:LspStop
	]]
end

keymap.declare {
	[{ 'n', silent = true, desc = 'Buffer: %s' }] = {
		['<C-b>n'] = { '<Cmd>enew<CR>', 'new' },
		['<C-b>r'] = { '<Cmd>e<CR>', 'reload' },
		['<C-b>c'] = { close_buffer, 'close' },
		['<C-b>C'] = { close_all_buffers, 'close all' },
		['}'] = { '<Cmd>bn<CR>', 'next' },
		['{'] = { '<Cmd>bp<CR>', 'previous' },
	},
}
