vim.go.clipboard = 'unnamedplus'

vim.go.hlsearch = false
vim.go.incsearch = true
vim.go.ignorecase = true
vim.go.smartcase = true

vim.go.undofile = true

vim.go.completeopt = 'menuone,noselect'

require 'settings.nvim.colorscheme'
require 'settings.nvim.editing'
require 'settings.nvim.environment'
require 'settings.nvim.lsp'
require 'settings.nvim.ui'
require 'settings.nvim.yank-highlight'
