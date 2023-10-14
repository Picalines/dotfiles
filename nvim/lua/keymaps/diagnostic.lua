local function nmap(key, func, desc)
    return vim.keymap.set('n', key, func, { desc = desc })
end

nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic message')
nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic message')
nmap('<leader>de', vim.diagnostic.open_float, 'Open floating diagnostic message')
nmap('<leader>dl', vim.diagnostic.setloclist, 'Open diagnostics list')
