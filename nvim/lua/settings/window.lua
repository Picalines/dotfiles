local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'
local win = require 'util.window'

local augroup = autocmd.group 'window'

vim.go.mouse = 'a'
vim.go.termguicolors = true

-- splits
vim.go.splitright = true
vim.go.splitbelow = true
vim.go.equalalways = false

-- keep space ahead when scrolling
vim.go.scrolloff = 8
vim.go.sidescrolloff = 16

-- global status line
vim.go.laststatus = 3
vim.go.showtabline = 2

-- left columns
vim.go.number = true
vim.go.relativenumber = true
vim.go.signcolumn = 'yes'

-- wrapping
vim.go.list = true
vim.go.wrap = true
vim.go.breakindent = true
vim.go.linebreak = true
vim.go.showbreak = '󱞩'
vim.go.listchars = 'tab:   ,trail:,extends:,precedes:,nbsp:'

-- fold
vim.go.foldmethod = 'expr'
vim.go.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.go.foldlevelstart = 9999
vim.go.foldtext = ''

-- fill chars
vim.opt.fillchars = {
	eob = ' ', -- no ~ at the end
	fold = ' ',
}

keymap {
	[{ 'n', desc = 'Window: %s' }] = {
		['<C-j>'] = { '<C-w>j', 'go down' },
		['<C-k>'] = { '<C-w>k', 'go up' },
		['<C-h>'] = { '<C-w>h', 'go left' },
		['<C-l>'] = { '<C-w>l', 'go right' },

		['<S-Down>'] = { '5<C-w>-', 'decrease height' },
		['<S-Up>'] = { '5<C-w>+', 'increase height' },
		['<S-Left>'] = { '5<C-w><', 'decrease width' },
		['<S-Right>'] = { '5<C-w>>', 'increase width' },

		['+'] = { '<Cmd>WinGrow 6<CR>', 'increase size' },
		['_'] = { '<Cmd>WinShrink 6<CR>', 'decrease size' },
	},

	[{ 'n', desc = 'UI: toggle %s' }] = {
		['<LocalLeader>n'] = { '<Cmd>set relativenumber!<CR>', 'relativenumber' },
		['<LocalLeader>b'] = { '<Cmd>set wrap!<CR>', 'break lines' },
		['<LocalLeader>s'] = { '<Cmd>set spell!<CR>', 'spell' },
	},
}

-- open help in vertical split
augroup:on('FileType', 'help', function(event)
	autocmd.buffer(event.buf):on('BufWinEnter', 'wincmd L')
	keymap {
		[{ 'n', buffer = event.buf }] = {
			['q'] = { '<C-w>c', 'close' },
		},
	}
end)

-- go to previous window when closing
augroup:on('WinClosed', '*', function(event)
	if event.match == tostring(vim.api.nvim_get_current_win()) then
		vim.cmd 'wincmd p'
	end
end)

augroup:on('TextYankPost', '*', function()
	vim.hl.on_yank()
end)

-- change width/height if the window's in a vertical/horizontal split
vim.api.nvim_create_user_command('WinGrow', function(args)
	local layout_type = win.layout_type()
	if layout_type == 'col' then
		vim.cmd.wincmd(args.count .. '+')
	elseif layout_type == 'row' then
		vim.cmd.wincmd(args.count .. '>')
	end
end, { count = 1 })

vim.api.nvim_create_user_command('WinShrink', function(args)
	local layout_type = win.layout_type()
	if layout_type == 'col' then
		vim.cmd.wincmd(args.count .. '-')
	elseif layout_type == 'row' then
		vim.cmd.wincmd(args.count .. '<')
	end
end, { count = 1 })
