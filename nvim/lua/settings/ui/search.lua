local autocmd = require 'util.autocmd'

vim.go.hlsearch = true
vim.go.incsearch = true
vim.go.ignorecase = true
vim.go.smartcase = true

local augroup = autocmd.group 'search'

augroup:on_user(
	'Dismiss',
	vim.schedule_wrap(function()
		vim.cmd 'nohlsearch'
	end)
)
