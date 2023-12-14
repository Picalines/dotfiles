vim.o.mouse = 'a'

vim.o.termguicolors = true

vim.wo.number = true

vim.wo.signcolumn = 'yes'

vim.o.wrap = false
vim.o.breakindent = true

vim.o.fillchars = 'eob: '

vim.opt.scrolloff = 8

local function define_sign(sign, text)
	return vim.fn.sign_define(sign, { text = text, texthl = sign })
end

define_sign('DiagnosticSignError', '')
define_sign('DiagnosticSignWarn', '')
define_sign('DiagnosticSignInfo', '')
define_sign('DiagnosticSignHint', '󰌵')
