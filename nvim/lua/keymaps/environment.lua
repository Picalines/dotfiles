local util = require 'keymaps.util'

local get_current_win = vim.api.nvim_get_current_win
local get_current_buf = vim.api.nvim_get_current_buf

local function bufremove()
	local win = get_current_win()
	local buf = get_current_buf()

	if vim.api.nvim_buf_get_option(0, 'modified') then
		vim.cmd ':w'
	end

	vim.cmd ':bp'

	if win == get_current_win() and buf == get_current_buf() then
		vim.cmd ':enew'
	end

	vim.cmd ':silent! bd #'
end

util.declare_keymaps {
	n = {
		['<leader>s'] = { util.cmds ':w', '[S]ave file' },

		['<leader>q'] = { util.cmds(':wa!', ':qa!'), '[Q]uit and save' },

		['<C-j>'] = { '<C-W>j', 'Move to bottom split' },
		['<C-k>'] = { '<C-W>k', 'Move to upper split' },
		['<C-h>'] = { '<C-W>h', 'Move to left split' },
		['<C-l>'] = { '<C-W>l', 'Move to right split' },

		['<S-Down>'] = { '<C-W>-', 'Decrease window height' },
		['<S-Up>'] = { '<C-W>+', 'Increase window height' },
		['<S-Left>'] = { '<C-W><', 'Decrease window width' },
		['<S-Right>'] = { '<C-W>>', 'Increase window width' },

		['<leader>t'] = { util.cmds ':tabnew', 'New [t]ab' },
		['<leader>dt'] = { util.cmds ':tabclose', 'Close [t]ab' },
		[']t'] = { util.cmds ':tabnext', 'Next [t]ab' },
		['[t'] = { util.cmds ':tabprev', 'Prev [t]ab' },
		['>t'] = { util.cmds ':tabmove +', 'Move [t]ab right' },
		['<t'] = { util.cmds ':tabmove -', 'Move [t]ab left' },

		['<leader>b'] = { util.cmds ':enew', 'New [b]uffer' },
		['<leader>db'] = { bufremove, 'Close [b]uffer' },
		[']b'] = { util.cmds ':bn', 'Next [b]uffer' },
		['[b'] = { util.cmds ':bp', 'Prev [b]uffer' },
	},
}
