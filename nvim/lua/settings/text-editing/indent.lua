local autocmd = require 'util.autocmd'

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

local augroup = autocmd.group 'indent'

augroup:on('FileType', { 'javascriptreact', 'typescriptreact' }, function()
	vim.bo.shiftwidth = 2
	vim.bo.tabstop = 2
	vim.bo.softtabstop = 2
end)
