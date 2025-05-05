local func = require 'util.func'
local keymap = require 'util.keymap'
local win = require 'util.window'

-- change width/height if the window's in a vertical/horizontal split
local function resize_smart(count)
	local layout_type = win.layout_type()
	if not layout_type or layout_type == 'leaf' then
		return
	end

	local cmd = tostring(math.abs(count))

	if layout_type == 'col' then
		cmd = cmd .. (count > 0 and '+' or '-')
	else
		cmd = cmd .. (count > 0 and '>' or '<')
	end

	vim.cmd.wincmd(cmd)
end

local function trigger_dismiss()
	vim.api.nvim_exec_autocmds('User', { pattern = 'Dismiss' })
end

keymap {
	[{ 'n', silent = true }] = {
		['<Esc>'] = { trigger_dismiss, 'Dismiss' },

		['<C-j>'] = { '<C-W>j', 'Move to bottom window' },
		['<C-k>'] = { '<C-W>k', 'Move to upper window' },
		['<C-h>'] = { '<C-W>h', 'Move to left window' },
		['<C-l>'] = { '<C-W>l', 'Move to right window' },

		['<S-Down>'] = { '5<C-W>-', 'Decrease window height' },
		['<S-Up>'] = { '5<C-W>+', 'Increase window height' },
		['<S-Left>'] = { '5<C-W><', 'Decrease window width' },
		['<S-Right>'] = { '5<C-W>>', 'Increase window width' },

		['+'] = { func.curry(resize_smart, 5), 'Increase window size' },
		['_'] = { func.curry(resize_smart, -5), 'Decrease window size' },
	},
	[{ 'i' }] = {
		['<C-d>'] = { trigger_dismiss, 'Dissmiss' },
	},
}
