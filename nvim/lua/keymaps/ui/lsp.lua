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

local function diagnostic_popup()
	local opened = vim.diagnostic.open_float { border = 'rounded' }
	if opened then
		vim.diagnostic.open_float() -- focus
	end
end

keymap {
	[{ 'n', desc = 'LSP: %s' }] = {
		['K'] = { '<Cmd>lua vim.lsp.buf.hover()<CR>', 'hover' },

		['<leader>r'] = { '<Cmd>lua vim.lsp.buf.rename()<CR>', 'rename' },
		['<leader>a'] = { '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'action' },

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
}
