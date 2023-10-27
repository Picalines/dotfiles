local function map_key(key, func, desc)
	return vim.keymap.set('n', key, func, { desc = desc })
end

map_key('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
map_key(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
map_key('<leader>dm', vim.diagnostic.open_float, 'Open floating diagnostic message')
map_key('<leader>dl', vim.diagnostic.setloclist, 'Open diagnostics list')
