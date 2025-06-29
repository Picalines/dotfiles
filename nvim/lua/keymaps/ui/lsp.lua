local keymap = require 'util.keymap'

local function toggle_inlay_hints()
	local enabled = not vim.lsp.inlay_hint.is_enabled()
	vim.lsp.inlay_hint.enable(enabled)
	print('inlay hints: ' .. (enabled and 'on' or 'off'))
end

keymap {
	[{ 'n', desc = 'LSP: %s' }] = {
		['K'] = { '<Cmd>lua vim.lsp.buf.hover()<CR>', 'hover' },

		['<leader>r'] = { '<Cmd>lua vim.lsp.buf.rename()<CR>', 'rename' },
		['<leader>a'] = { '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'action' },

		['<leader>li'] = { '<Cmd>LspInfo<CR>', 'See info' },
		['<leader>lr'] = { '<Cmd>echo "Restarting LSP" | LspRestart<CR>', 'Restart' },
		['<leader>ll'] = { '<Cmd>LspLog<CR>', 'See logs' },
		['<leader>ui'] = { toggle_inlay_hints, 'Toggle inlay hints' },

		['<C-w>d'] = { '<Cmd>lua vim.diagnostic.open_float()<CR>', 'open diagnostic' },
	},
}
