local autocmd = require 'util.autocmd'

local augroup = autocmd.group 'buflisted'

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
