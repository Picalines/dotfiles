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

local function toggle_background()
	vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
end

keymap {
	[{ 'n' }] = {
		['<leader><leader>q'] = { '<Cmd>wqa<CR>', 'Write all and quit' },

		['<Esc>'] = { '<Cmd>doautocmd User Dismiss<CR>', 'Dismiss' },

		[{ desc = 'Window: %s' }] = {
			['<C-j>'] = { '<C-W>j', 'move to bottom' },
			['<C-k>'] = { '<C-W>k', 'move to upper' },
			['<C-h>'] = { '<C-W>h', 'move to left' },
			['<C-l>'] = { '<C-W>l', 'move to right' },

			['<S-Down>'] = { '5<C-W>-', 'decrease height' },
			['<S-Up>'] = { '5<C-W>+', 'increase height' },
			['<S-Left>'] = { '5<C-W><', 'decrease width' },
			['<S-Right>'] = { '5<C-W>>', 'increase width' },

			['+'] = { func.partial(resize_smart, 5), 'increase size' },
			['_'] = { func.partial(resize_smart, -5), 'decrease size' },
		},

		[{ desc = 'UI: %s' }] = {
			['<leader>ul'] = { toggle_background, 'toggle background' },
		},
	},

	[{ 'i' }] = {
		['<C-d>'] = { '<Cmd>doautocmd User Dismiss<CR>', 'Dismiss' },
	},
}
