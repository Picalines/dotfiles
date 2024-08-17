local autocmd = require 'util.autocmd'
local func = require 'util.func'

vim.go.mouse = 'a'
vim.go.termguicolors = true
vim.go.equalalways = true

vim.go.wrap = false
vim.go.breakindent = true

vim.go.matchpairs = vim.o.matchpairs .. ',<:>'

vim.wo.scrolloff = 8

vim.go.number = true
vim.go.relativenumber = true
vim.go.signcolumn = 'yes'

vim.go.fillchars = 'eob: '
vim.go.showbreak = '󱞩'
vim.go.linebreak = true

autocmd.per_filetype('help', func.cmd 'wincmd L')
