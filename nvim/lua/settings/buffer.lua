local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

-- highlight <>
vim.o.matchpairs = vim.go.matchpairs .. ',<:>'

keymap {
	[{ 'n', desc = 'Buffer: %s' }] = {
		[']b'] = { '<Cmd>bn<CR>', 'next' },
		['[b'] = { '<Cmd>bp<CR>', 'previous' },

		['<LocalLeader>bn'] = { '<Cmd>enew<CR>', 'new' },
		['<LocalLeader>br'] = { '<Cmd>e<CR>', 'reload' },
		['<LocalLeader>bt'] = { '<Cmd>term<CR>', 'terminal' },

		['<LocalLeader>w'] = { '<Cmd>silent w<CR>', 'write' },
		['<Leader>w'] = { '<Cmd>silent wa!<CR>', 'write all' },

		['<LocalLeader>s'] = { ':%s///g<Left><Left><Left>', 'substitute' },
		['<LocalLeader>gn'] = { ':%g//norm <Left><Left><Left><Left><Left><Left>', 'g norm' },
	},

	[{ 'x', desc = 'Buffer: %s' }] = {
		['<LocalLeader>s'] = { ':s///g<Left><Left><Left>', 'substitute' },
		['<LocalLeader>gn'] = { ':g//norm <Left><Left><Left><Left><Left><Left>', 'g norm' },
	},
}

local augroup = autocmd.group 'buffer'

local unlisted_buftypes = {
	'help',
	'prompt',
	'quickfix',
}

augroup:on({ 'BufNew', 'BufAdd', 'BufWinEnter', 'TermOpen' }, '*', function(event)
	local bo = vim.bo[event.buf]
	if vim.list_contains(unlisted_buftypes, bo.buftype) then
		bo.buflisted = false
	end
end)

augroup:on('FileType', 'qf', function(event)
	keymap {
		[{ 'n', remap = true, buffer = event.buf, desc = 'Quickfix: %s' }] = {
			['q'] = { '<Cmd>cclose<CR>', 'close' },
			['<Leader>q'] = { '<Cmd>cclose<CR>', 'close' },
		},
	}
end)
