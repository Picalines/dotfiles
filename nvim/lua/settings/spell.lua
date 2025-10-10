local autocmd = require 'util.autocmd'
local options = require 'util.options'

-- NOTE: netrw is needed. Without it, neovim doesn't show the download prompt at startup
vim.opt_global.spelllang = { 'en_us', 'ru_yo' }
vim.opt_global.spellfile = (vim.fn.stdpath 'config') .. '/spell/words.utf-8.add'
vim.opt_global.spelloptions = { 'camel' }

local augroup = autocmd.group 'spell'

augroup:on('BufWinEnter', '*', function(event)
	local bo, wo = options.buflocal(event.buf)
	wo.spell = bo.buftype == ''
end)

augroup:on('TermOpen', '*', 'set nospell')

augroup:on({ 'DirChanged', 'VimEnter' }, '*', function()
	local cwd = vim.fs.basename(vim.fn.getcwd(-1))
	vim.cmd('silent spellgood! ' .. cwd)
end)

vim.cmd('silent spellgood! ' .. os.getenv 'USER')
