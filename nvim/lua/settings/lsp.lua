local keymap = require 'util.keymap'

keymap {
	[{ 'n', desc = 'LSP: %s' }] = {
		-- built-in: K, <C-w>d, ]d, [d
		['<LocalLeader>r'] = { '<Cmd>lua vim.lsp.buf.rename()<CR>', 'rename' },
		['<LocalLeader>a'] = { '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'action' },
	},

	[{ 'n', desc = 'UI: %s' }] = {
		['<Leader>oi'] = {
			desc = 'toggle inlay hints',
			function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end,
		},
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
