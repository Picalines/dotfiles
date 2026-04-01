local keymap = require 'mappet'
local map = keymap.map

local keys = keymap.group 'settings.lsp'

keys 'LSP: %s' {
	map('<LocalLeader>r', 'rename') { vim.lsp.buf.rename },
	map('<LocalLeader>a', 'action') { vim.lsp.buf.code_action },

	map('<LocalLeader>lR', 'restart') '<Cmd>lsp restart<CR>',

	map('<LocalLeader>lf', 'format') { vim.lsp.buf.format },
	map('<LocalLeader>lc', 'convert color') { vim.lsp.document_color.color_presentation },
	map('<LocalLeader>li', 'inlay hints') {
		function()
			local filter = { bufnr = 0 }
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
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

vim.lsp.config('lua_ls', {
	settings = {
		Lua = { telemetry = { enable = false } },
	},
})

vim.lsp.config('vtsls', {
	settings = {
		typescript = {
			preferences = {
				preferTypeOnlyAutoImports = true,
			},
		},
	},
})

vim.lsp.config('tailwindcss', {
	settings = {
		tailwindCSS = {
			classFunctions = { 'tw', 'clsx', 'cva', 'cn' },
			classAttributes = { 'class', 'className', 'ngClass', 'class:list' },
		},
	},
})

vim.lsp.config('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			cargo = { features = 'all' },
		},
	},
})
