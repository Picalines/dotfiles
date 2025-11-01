local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

-- tabs
vim.go.tabstop = 4
vim.go.softtabstop = 4
vim.go.shiftwidth = 4
vim.go.expandtab = true

-- highlight <>
vim.go.matchpairs = vim.go.matchpairs .. ',<:>'

keymap {
	[{ 'n', silent = true, desc = 'Buffer: %s' }] = {
		[']b'] = { '<Cmd>bn<CR>', 'next' },
		['[b'] = { '<Cmd>bp<CR>', 'previous' },

		['<LocalLeader>bn'] = { '<Cmd>enew<CR>', 'new' },
		['<LocalLeader>br'] = { '<Cmd>e<CR>', 'reload' },
	},
}

local augroup = autocmd.group 'buffer'

local unlisted_buftypes = {
	'help',
	'prompt',
	'quickfix',
	'terminal',
}

augroup:on({ 'BufNew', 'BufAdd', 'BufWinEnter', 'TermOpen' }, '*', function(event)
	local bo = vim.bo[event.buf]
	if vim.list_contains(unlisted_buftypes, bo.buftype) then
		bo.buflisted = false
	end
end)
