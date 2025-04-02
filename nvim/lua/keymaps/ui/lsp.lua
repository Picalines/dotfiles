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

-- NOTE: for some reason i have to move this to a function
local function hover()
	vim.lsp.buf.hover()
end

local function signature_help()
	vim.lsp.buf.signature_help()
end

local function diagnostic_popup()
	local opened = vim.diagnostic.open_float { border = 'rounded' }
	if opened then
		vim.diagnostic.open_float() -- focus
	end
end

keymap.declare {
	[{ 'n', desc = 'LSP: %s' }] = {
		['K'] = { hover, 'Hover' },
		['<C-S>'] = { signature_help, 'Signature help' },

		['<leader>r'] = { vim.lsp.buf.rename, 'Rename' },
		['<leader>a'] = { vim.lsp.buf.code_action, 'Code action' },

		['gD'] = { '<Cmd>Telescope lsp_definitions<CR>', 'Go to definition' },
		['gR'] = { '<Cmd>Telescope lsp_references<CR>', 'Go to references' },
		['gI'] = { '<Cmd>Telescope lsp_implementations<CR>', 'Go to implementation' },
		['gT'] = { '<Cmd>Telescope lsp_type_definitions<CR>', 'Go to type definition' },

		['<leader>li'] = { '<Cmd>LspInfo<CR>', 'See info' },
		['<leader>lr'] = { '<Cmd>echo "Restarting LSP" | LspRestart<CR>', 'Restart' },
		['<leader>ll'] = { '<Cmd>LspLog<CR>', 'See logs' },
		['<leader>ui'] = { toggle_inlay_hints, 'Toggle inlay hints' },
		['<leader>ls'] = { ':LspStart ', 'Start server' },

		['<C-w>d'] = { diagnostic_popup, 'Diagnostics popup' },
	},

	[{ 'i', desc = 'LSP: %s' }] = {
		['<C-S>'] = { signature_help, 'Signature help' },
	},
}
