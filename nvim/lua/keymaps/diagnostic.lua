local function map_key(key, func, desc)
	return vim.keymap.set('n', key, func, { desc = desc })
end

map_key('[D', vim.diagnostic.goto_prev, 'Go to previous [d]iagnostic')
map_key(']D', vim.diagnostic.goto_next, 'Go to next [d]iagnostic')
map_key('<leader>Dm', vim.diagnostic.open_float, 'Open [d]iagnostic [m]essage')
map_key('<leader>Dl', vim.diagnostic.setloclist, 'Open [d]iagnostics [l]ist')
