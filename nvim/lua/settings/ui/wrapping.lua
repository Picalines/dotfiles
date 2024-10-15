local autocmd = require 'util.autocmd'
local func = require 'util.func'

vim.go.wrap = false
vim.go.breakindent = true
vim.go.showbreak = '󱞩'
vim.go.linebreak = true

local augroup = autocmd.group 'wrapping'

augroup:on_filetype({ 'javascriptreact', 'typescriptreact', 'markdown' }, func.cmd 'setlocal wrap')
