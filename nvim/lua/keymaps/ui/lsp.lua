local keymap = require 'util.keymap'
local signal = require 'util.signal'

local lsp_inlay_enabled = signal.new(false)
signal.persist(lsp_inlay_enabled, 'lsp.inlay_hints')
signal.watch(function()
	vim.lsp.inlay_hint.enable(lsp_inlay_enabled())
end)

local function toggle_inlay_hints()
	local is_enabled = lsp_inlay_enabled(not lsp_inlay_enabled())
	print('Inlay hints: ' .. (is_enabled and 'on' or 'off'))
end

keymap.declare {
	[{ 'n', silent = true }] = {
		['K'] = { vim.lsp.buf.hover, 'LSP: Hover' },

		['<leader>r'] = { vim.lsp.buf.rename, 'LSP: Rename' },
		['<leader>a'] = { vim.lsp.buf.code_action, 'LSP: Code action' },

		['gD'] = { '<Cmd>Glance definitions<CR>', 'LSP: Go to definition' },
		['gR'] = { '<Cmd>Glance references<CR>', 'LSP: Go to references' },
		['gI'] = { '<Cmd>Glance implementations<CR>', 'LSP: Go to implementation' },
		['gT'] = { '<Cmd>Glance type_definitions<CR>', 'LSP: Go to type definition' },
		['gC'] = { vim.lsp.buf.declaration, 'LSP: Go to to Declaration' },

		['<leader>li'] = { '<Cmd>LspInfo<CR>', 'LSP: See info' },
		['<leader>lr'] = { '<Cmd>echo "Restarting LSP" | LspRestart<CR>', 'LSP: Restart' },
		['<leader>ll'] = { '<Cmd>LspLog<CR>', 'LSP: See logs' },
		['<leader>lh'] = { toggle_inlay_hints, 'LSP: Toggle inlay hints' },
		['<leader>ls'] = { ':LspStart ', 'LSP: Start server' },
	},

	[{ 'i' }] = {
		['<C-S>'] = { vim.lsp.buf.signature_help, 'LSP: show signature help' },
	},
}
