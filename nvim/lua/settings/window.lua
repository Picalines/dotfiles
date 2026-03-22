local autocmd = require 'util.autocmd'
local keymap = require 'mappet'
local win = require 'util.window'

local map = keymap.map
local sub = keymap.sub
local keys = keymap.group 'settings.window'
local help_keys = keymap.template()

local augroup = autocmd.group 'window'

vim.o.mouse = 'a'
vim.o.termguicolors = true

-- splits
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.equalalways = false

-- keep space ahead when scrolling
vim.o.scrolloff = 8
vim.o.sidescrolloff = 16

-- global status line
vim.o.laststatus = 3
vim.o.showtabline = 0

-- left columns
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'

-- wrapping
vim.o.list = true
vim.o.wrap = true
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.showbreak = '󱞩'
vim.opt.listchars = {
	tab = '   ',
	trail = '',
	extends = '',
	precedes = '',
	nbsp = '',
}

-- fold
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldtext = ''

-- fill chars
vim.opt.fillchars = {
	eob = ' ', -- no ~ at the end
	fold = ' ',
	diff = '╱',
}

keys('Window: %s', { 'n' }) {
	sub 'go %s' {
		map('<C-j>', 'down') '<C-w>j',
		map('<C-k>', 'up') '<C-w>k',
		map('<C-h>', 'left') '<C-w>h',
		map('<C-l>', 'right') '<C-w>l',
	},

	map('<S-Down>', 'decrease height') '5<C-w>-',
	map('<S-Up>', 'increase height') '5<C-w>+',
	map('<S-Left>', 'decrease width') '5<C-w><',
	map('<S-Right>', 'increase width') '5<C-w>>',

	map('+', 'increase size') '<Cmd>WinGrow 6<CR>',
	map('_', 'decrease size') '<Cmd>WinShrink 6<CR>',
}

keys('UI: toggle %s', { 'n' }) {
	map('<LocalLeader>on', 'relativenumber') '<Cmd>set relativenumber!<CR>',
	map('<LocalLeader>ow', 'wrap') '<Cmd>set wrap!<CR>',
	map('<LocalLeader>os', 'spell') '<Cmd>set spell!<CR>',
}

help_keys { 'n' } {
	map('q', 'close') '<C-w>c',
}

-- open help in vertical split
augroup:on('FileType', 'help', function(event)
	autocmd.buffer(event.buf):on('BufWinEnter', 'wincmd L')
	help_keys:apply(keymap.buffer('settings.window.help', event.buf))
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
