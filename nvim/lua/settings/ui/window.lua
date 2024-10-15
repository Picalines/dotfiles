local autocmd = require 'util.autocmd'
local func = require 'util.func'

vim.go.mouse = 'a'
vim.go.termguicolors = true
vim.go.equalalways = true

vim.go.scrolloff = 8

local augroup = autocmd.group 'window'

augroup:on_filetype('help', func.cmd 'wincmd L')
