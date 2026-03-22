local autocmd = require 'util.autocmd'

local keymap = require 'mappet'
local map = keymap.map

local keys = keymap.group 'settings.buffer'
local qf_keys = keymap.template()

-- highlight <>
vim.o.matchpairs = vim.go.matchpairs .. ',<:>'

keys 'Buffer: %s' {
	map(']b', 'next') '<Cmd>bn<CR>',
	map('[b', 'previous') '<Cmd>bp<CR>',

	map('<LocalLeader>bn', 'new') '<Cmd>enew<CR>',
	map('<LocalLeader>br', 'reload') '<Cmd>e<CR>',
	map('<LocalLeader>bt', 'terminal') '<Cmd>term<CR>',

	map('<LocalLeader>w', 'write') '<Cmd>silent w<CR>',
	map('<Leader>w', 'write all') '<Cmd>silent wa!<CR>',

	map('<LocalLeader>s', 'substitute') ':%s///g<Left><Left><Left>',
	map('<LocalLeader>gn', 'g norm') ':%g//norm <Left><Left><Left><Left><Left><Left>',
}

keys('Buffer: %s', { 'x' }) {
	map('<LocalLeader>s', 'substitute') ':s///g<Left><Left><Left>',
	map('<LocalLeader>gn', 'g norm') ':g//norm <Left><Left><Left><Left><Left><Left>',
}

qf_keys('Quickfix: %s', { remap = true }) {
	map('q', 'close') '<Cmd>cclose<CR>',
	map('<Leader>q', 'close') '<Cmd>cclose<CR>',
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
	local buffer_keys = keymap.buffer('quickfix', event.buf)
	qf_keys:apply(buffer_keys)
end)
