local array = require 'util.array'
local autocmd = require 'util.autocmd'

local function disable_buflisted(event)
	vim.api.nvim_set_option_value('buflisted', false, { buf = event.buf })
end

local augroup = autocmd.group 'buflisted'

local unlisted_buftypes = {
	'help',
	'prompt',
	'quickfix',
	'terminal',
}

augroup:on({ 'BufNew', 'BufAdd', 'BufWinEnter', 'TermOpen' }, '*', function(event)
	local buftype = vim.api.nvim_get_option_value('buftype', { buf = event.buf })
	if array.contains(unlisted_buftypes, buftype) then
		disable_buflisted(event)
	end
end)
