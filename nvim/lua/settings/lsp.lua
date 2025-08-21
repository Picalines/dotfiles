local func = require 'util.func'
local keymap = require 'util.keymap'

keymap {
	[{ 'n', desc = 'LSP: %s' }] = {
		['K'] = { '<Cmd>lua vim.lsp.buf.hover()<CR>', 'hover' },
		['<C-w>d'] = { '<Cmd>lua vim.diagnostic.open_float()<CR>', 'diagnostic' },

		['<leader>r'] = { '<Cmd>lua vim.lsp.buf.rename()<CR>', 'rename' },
		['<leader>a'] = { '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'action' },

		['<leader>li'] = { '<Cmd>LspInfo<CR>', 'info' },
		['<leader>lr'] = { '<Cmd>echo "Restarting LSP" | LspRestart<CR>', 'restart' },
		['<leader>ll'] = { '<Cmd>LspLog<CR>', 'logs' },
	},

	[{ 'n' }] = {
		[{ silent = true }] = {
			['[d'] = { func.partial(vim.diagnostic.jump, { count = -1, float = false }), 'previous diagnostic' },
			[']d'] = { func.partial(vim.diagnostic.jump, { count = 1, float = false }), 'next diagnostic' },
		},
	},

	[{ 'n', desc = 'UI: %s' }] = {
		['<leader>ui'] = {
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

	virtual_lines = false,
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
