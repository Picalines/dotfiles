local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'
local options = require 'util.options'

local augroup = autocmd.group 'window'

vim.go.mouse = 'a'
vim.go.termguicolors = true

vim.go.splitright = true
vim.go.splitbelow = true
vim.go.equalalways = false

vim.go.scrolloff = 8
vim.go.sidescrolloff = 16

vim.go.laststatus = 3 -- global statusline

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

augroup:on('FileType', 'help', function(event)
	autocmd.buffer(event.buf):on('BufWinEnter', 'wincmd L')

	keymap {
		[{ 'n', buffer = event.buf }] = {
			['q'] = { '<C-w>c', 'close' },
		},
	}
end)

augroup:on('ExitPre', '*', function()
	for _, chan in ipairs(vim.api.nvim_list_chans()) do
		if chan.mode == 'terminal' and chan.stream == 'job' then
			vim.fn.jobstop(chan.id)
			print('stopping', chan.id)
		end
	end
end)
