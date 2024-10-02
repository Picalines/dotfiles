local autocmd = require 'util.autocmd'

vim.go.hlsearch = false
vim.go.incsearch = true
vim.go.ignorecase = true
vim.go.smartcase = true

autocmd.on('CmdlineEnter', { '/', '?' }, 'set hlsearch')
autocmd.on_user('Dismiss', 'set nohlsearch')
