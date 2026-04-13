local autocmd = require 'util.autocmd'

-- NOTE: netrw is needed. Without it, neovim doesn't show the download prompt at startup
vim.opt.spell = false
vim.opt.spelllang = { 'en_us', 'ru_yo' }
vim.opt.spellfile = (vim.fn.stdpath 'config') .. '/spell/words.utf-8.add'
vim.opt.spelloptions = { 'camel' }

local augroup = autocmd.group 'spell'

augroup:on('FileType', '*', function()
	vim.wo.spell = vim.bo.buftype == ''
end)

augroup:on('FileType', 'snippets', 'set nospell')

augroup:on('TermOpen', '*', 'set nospell')
