local autocmd = require 'util.autocmd'

local augroup = autocmd.group 'text-editing-settings'

-- sync with system clipboard
vim.go.clipboard = 'unnamedplus'

-- tabs
vim.go.tabstop = 4
vim.go.softtabstop = 4
vim.go.shiftwidth = 4
vim.go.expandtab = true

-- highlight <>
vim.go.matchpairs = vim.go.matchpairs .. ',<:>'

-- persist undo history
vim.go.undofile = true

-- auto refresh files
vim.go.autoread = true
augroup:on({ 'FocusGained', 'TermLeave' }, '*', 'checktime')
