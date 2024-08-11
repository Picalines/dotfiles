local autocmd = require 'util.autocmd'
local func = require 'util.func'

vim.o.mouse = 'a'

vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true

vim.wo.signcolumn = 'yes'

vim.o.wrap = false
vim.o.breakindent = true

vim.o.fillchars = 'eob: '
vim.o.showbreak = '󱞩'
vim.o.linebreak = true

vim.o.matchpairs = vim.o.matchpairs .. ',<:>'

vim.o.scrolloff = 8

vim.o.equalalways = true

autocmd.per_filetype('help', func.cmd 'wincmd L')
