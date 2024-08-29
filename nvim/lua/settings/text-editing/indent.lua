local autocmd = require 'util.autocmd'

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

autocmd.on_filetype({ 'javascriptreact', 'typescriptreact' }, function()
	vim.bo.tabstop = 2
	vim.bo.softtabstop = 2
	vim.bo.shiftwidth = 2
end)
