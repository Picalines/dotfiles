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

vim.opt.scrolloff = 8

autocmd.per_filetype('help', func.cmd 'wincmd L')
