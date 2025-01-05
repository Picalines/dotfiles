local autocmd = require 'util.autocmd'

vim.go.mouse = 'a'
vim.go.termguicolors = true
vim.go.equalalways = true

vim.go.scrolloff = 8

local augroup = autocmd.group 'window'

augroup:on('FileType', 'help', function(event)
	autocmd.buffer(event.buf):on('BufWinEnter', 'wincmd L', { once = true })
end)
