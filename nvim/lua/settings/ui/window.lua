local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

local augroup = autocmd.group 'window'

vim.go.mouse = 'a'
vim.go.termguicolors = true

vim.go.splitright = true
vim.go.splitbelow = true
vim.go.equalalways = false

vim.go.scrolloff = 8
vim.go.sidescrolloff = 16

vim.go.laststatus = 3 -- global statusline
vim.go.showtabline = 2

vim.go.number = true
vim.go.relativenumber = true
vim.go.signcolumn = 'yes'

vim.go.fillchars = 'eob: '

vim.go.list = true
vim.go.listchars = 'tab:   ,trail:,extends:,precedes:,nbsp:'

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
