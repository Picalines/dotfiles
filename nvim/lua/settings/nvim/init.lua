vim.o.clipboard = 'unnamedplus'

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.undofile = true

vim.o.completeopt = 'menuone,noselect'

vim.o.ignorecase = true
vim.o.smartcase = true

require 'settings.nvim.editing'
require 'settings.nvim.environment'
require 'settings.nvim.lsp'
require 'settings.nvim.ui'
require 'settings.nvim.yank-highlight'
