local autocmd = require 'util.autocmd'
local func = require 'util.func'

vim.go.wrap = false
vim.go.breakindent = true
vim.go.showbreak = '󱞩'
vim.go.linebreak = true

autocmd.per_filetype({ 'javascriptreact', 'typescriptreact', 'markdown' }, func.cmd 'setlocal wrap')
