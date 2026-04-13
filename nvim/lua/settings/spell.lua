local autocmd = require 'util.autocmd'
local options = require 'util.options'

-- NOTE: netrw is needed. Without it, neovim doesn't show the download prompt at startup
vim.opt.spelllang = { 'en_us', 'ru_yo' }
vim.opt.spellfile = (vim.fn.stdpath 'config') .. '/spell/words.utf-8.add'
vim.opt.spelloptions = { 'camel' }

local augroup = autocmd.group 'spell'

augroup:on('BufWinEnter', '*', function(event)
	local bo, wo = options.buflocal(event.buf)
	wo.spell = bo.buftype == ''
end)

augroup:on('TermOpen', '*', 'set nospell')
augroup:on('BufWinEnter', '*.snippets', 'set nospell')
