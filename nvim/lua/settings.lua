vim.o.termguicolors = true

vim.o.hlsearch = false
vim.o.incsearch = true

vim.wo.number = true

vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.wrap = false

vim.opt.scrolloff = 8

vim.o.fillchars = 'eob: '

vim.o.autoread = true

local define_sign = vim.fn.sign_define
define_sign('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
define_sign('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
define_sign('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
define_sign('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })
