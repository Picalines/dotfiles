require('keymaps.util').declare_keymaps {
	n = {
		['[d'] = { vim.diagnostic.goto_prev, 'Go to previous [d]iagnostic' },
		[']d'] = { vim.diagnostic.goto_next, 'Go to next [d]iagnostic' },
		['<leader>Dm'] = { vim.diagnostic.open_float, 'Open [d]iagnostic [m]essage' },
		['<leader>Dl'] = { vim.diagnostic.setloclist, 'Open [d]iagnostics [l]ist' },
	},
}
