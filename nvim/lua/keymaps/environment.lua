local util = require 'keymaps.util'

local function is_buffer_modified(buffer)
	return vim.api.nvim_buf_get_option(buffer, 'modified')
end

local function save_buffer()
	local filename = vim.api.nvim_buf_get_name(0)

	if filename == '' then
		filename = vim.fn.input { prompt = 'Save to: ' } or ''
	end

	if filename ~= '' then
		vim.cmd(':silent! w ' .. filename)
	end
end

local function remove_buffer()
	local get_current_win = vim.api.nvim_get_current_win
	local get_current_buf = vim.api.nvim_get_current_buf

	local win = get_current_win()
	local buf = get_current_buf()

	if is_buffer_modified(0) then
		save_buffer()
	end

	vim.cmd ':bp'

	if win == get_current_win() and buf == get_current_buf() then
		vim.cmd ':enew'
	end

	vim.cmd ':silent! bd #'
end

local function quit_and_save()
	for _, buffer in pairs(vim.api.nvim_list_bufs()) do
		if is_buffer_modified(buffer) and vim.api.nvim_buf_get_name(buffer) == '' then
			vim.api.nvim_set_current_buf(buffer)
			return
		end
	end

	vim.cmd ':wa!'
	vim.cmd ':qa!'
end

util.declare_keymaps {
	opts = {
		silent = true,
	},
	n = {
		['<leader>s'] = { save_buffer, '[S]ave file' },

		['<leader>q'] = { quit_and_save, '[Q]uit and save' },

		['<C-j>'] = { '<C-W>j', 'Move to bottom split' },
		['<C-k>'] = { '<C-W>k', 'Move to upper split' },
		['<C-h>'] = { '<C-W>h', 'Move to left split' },
		['<C-l>'] = { '<C-W>l', 'Move to right split' },

		['<S-Down>'] = { '<C-W>-', 'Decrease window height' },
		['<S-Up>'] = { '<C-W>+', 'Increase window height' },
		['<S-Left>'] = { '<C-W><', 'Decrease window width' },
		['<S-Right>'] = { '<C-W>>', 'Increase window width' },

		['<leader>t'] = { ':tabnew<CR>', 'New [t]ab' },
		['<leader>dt'] = { ':tabclose<CR>', 'Close [t]ab' },
		[']t'] = { ':tabnext<CR>', 'Next [t]ab' },
		['[t'] = { ':tabprev<CR>', 'Prev [t]ab' },
		['>t'] = { ':tabmove +<CR>', 'Move [t]ab right' },
		['<t'] = { ':tabmove -<CR>', 'Move [t]ab left' },

		['<leader>b'] = { util.cmds ':enew', 'New [b]uffer' },
		['<leader>db'] = { remove_buffer, 'Close [b]uffer' },
		[']b'] = { ':bn<CR>', 'Next [b]uffer' },
		['[b'] = { ':bp<CR>', 'Prev [b]uffer' },
	},
}
