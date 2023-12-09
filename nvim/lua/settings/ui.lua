vim.o.mouse = 'a'

vim.o.termguicolors = true

vim.wo.number = true

vim.wo.signcolumn = 'yes'

vim.o.wrap = false
vim.o.breakindent = true

vim.o.fillchars = 'eob: '

vim.opt.scrolloff = 8

local define_sign = vim.fn.sign_define
define_sign('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
define_sign('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
define_sign('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
define_sign('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })
