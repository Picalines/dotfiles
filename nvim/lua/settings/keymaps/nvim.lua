local util = require 'util'

local function is_modified(buffer)
	return vim.api.nvim_buf_get_option(buffer, 'modified')
end

local function quit_and_save()
	for _, buffer in pairs(vim.api.nvim_list_bufs()) do
		if is_modified(buffer) and vim.api.nvim_buf_get_name(buffer) == '' then
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
		['<leader>q'] = { quit_and_save, '[Q]uit and save' },
	},
}
