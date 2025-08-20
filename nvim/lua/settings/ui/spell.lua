local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'
local options = require 'util.options'

local go = vim.opt_global

-- NOTE: netrw is needed. Without it, neovim doesn't show the download prompt at startup
go.spelllang = { 'en_us', 'ru_yo' }
go.spellfile = (vim.fn.stdpath 'config') .. '/spell/custom.utf-8.add'
go.spelloptions = { 'camel' }

keymap {
	[{ 'n', desc = 'UI: %s' }] = {
		['<leader>us'] = { '<Cmd>set spell!<CR>', 'toggle spell' },
	},
}

local augroup = autocmd.group 'spell'

augroup:on('BufWinEnter', '*', function(event)
	local bo, wo = options.buflocal(event.buf)

	if bo.buftype == '' then
		wo.spell = true
	end
end)

augroup:on({ 'DirChanged', 'VimEnter' }, '*', function()
	local cwd = vim.fs.basename(vim.fn.getcwd(-1))
	vim.cmd('silent spellgood! ' .. cwd)
end)

vim.cmd('silent spellgood! ' .. os.getenv 'USER')
