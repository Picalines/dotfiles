local keymap = require 'mappet'
local map = keymap.map

local keys = keymap.group 'settings.lsp'

keys 'LSP: %s' {
	map('<LocalLeader>r', 'rename') '<Cmd>lua vim.lsp.buf.rename()<CR>',
	map('<LocalLeader>a', 'action') '<Cmd>lua vim.lsp.buf.code_action()<CR>',
}

keys('UI: %s', { 'n' }) {
	map('<Leader>oi', 'toggle inlay hints') {
		function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end,
	},
}

vim.diagnostic.config {
	update_in_insert = true,
	severity_sort = true,

	virtual_text = {
		current_line = true,
	},

	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '󰅝',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '',
		},
	},

	float = {
		source = 'if_many',
		border = 'rounded',
	},
}
