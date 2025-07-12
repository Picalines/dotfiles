local autocmd = require 'util.autocmd'
local options = require 'util.options'

local augroup = autocmd.group 'window'

vim.go.mouse = 'a'
vim.go.termguicolors = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.go.scrolloff = 8
vim.go.sidescrolloff = 16

vim.o.laststatus = 3 -- global statusline

vim.go.number = true
vim.go.relativenumber = true
vim.go.signcolumn = 'yes'

vim.go.fillchars = 'eob: '

vim.go.list = true
vim.go.listchars = 'tab:   ,trail:,extends:,precedes:,nbsp:'

augroup:on({ 'TabNew', 'WinNew', 'WinEnter', 'BufWinEnter', 'TermOpen' }, '*', function()
	local tab_winids = vim.api.nvim_tabpage_list_wins(0)

	local has_normal_bufs = vim.iter(tab_winids):any(function(winid)
		local _, bo = options.winlocal(winid)
		local config = vim.api.nvim_win_get_config(winid)
		return bo.buftype == '' and config.relative == ''
	end)

	vim.o.showtabline = has_normal_bufs and 2 or 1 -- always OR only when #tabpages > 1
end)

augroup:on('TextYankPost', '*', function()
	vim.highlight.on_yank()
end)
