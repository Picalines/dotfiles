local keymap = require 'util.keymap'
local signal = require 'util.signal'

local lsp_inlay_enabled = signal.new(false)
signal.persist(lsp_inlay_enabled, 'vim.lsp.inlay_hints')
signal.watch(function()
	local is_enabled = lsp_inlay_enabled()
	vim.lsp.inlay_hint.enable(is_enabled)
	vim.g.status_lsp_inlay_hints_enabled = is_enabled
end)

local function toggle_inlay_hints()
	local is_enabled = lsp_inlay_enabled(not lsp_inlay_enabled())
	print('Inlay hints: ' .. (is_enabled and 'on' or 'off'))
end

keymap.declare {
	[{ 'n', desc = 'LSP: %s' }] = {
		['K'] = { vim.lsp.buf.hover, 'Hover' },
		['<C-S>'] = { vim.lsp.buf.signature_help, 'Signature help' },

		['<leader>r'] = { vim.lsp.buf.rename, 'Rename' },
		['<leader>a'] = { vim.lsp.buf.code_action, 'Code action' },

		['gD'] = { vim.lsp.buf.definition, 'Go to definition' },
		['gR'] = { vim.lsp.buf.references, 'Go to references' },
		['gI'] = { vim.lsp.buf.implementation, 'Go to implementation' },
		['gT'] = { vim.lsp.buf.type_definition, 'Go to type definition' },
		['gC'] = { vim.lsp.buf.declaration, 'Go to to Declaration' },

		['<leader>li'] = { '<Cmd>LspInfo<CR>', 'See info' },
		['<leader>lr'] = { '<Cmd>echo "Restarting LSP" | LspRestart<CR>', 'Restart' },
		['<leader>ll'] = { '<Cmd>LspLog<CR>', 'See logs' },
		['<leader>ih'] = { toggle_inlay_hints, 'Toggle inlay hints' },
		['<leader>ls'] = { ':LspStart ', 'Start server' },
	},

	[{ 'i', desc = 'LSP: %s' }] = {
		['<C-S>'] = { vim.lsp.buf.signature_help, 'Signature help' },
	},
}
