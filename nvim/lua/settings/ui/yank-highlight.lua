local autocmd = require 'util.autocmd'

local augroup = autocmd.group 'yank-highlight'

augroup:on('TextYankPost', '*', function()
	vim.highlight.on_yank()
end)
