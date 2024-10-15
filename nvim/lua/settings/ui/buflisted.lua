local autocmd = require 'util.autocmd'

local function disable_buflisted(event)
	vim.api.nvim_set_option_value('buflisted', false, { buf = event.buf })
end

local augroup = autocmd.group 'buflisted'

augroup:on_filetype({ 'qf' }, disable_buflisted)
augroup:on('TermOpen', '*', disable_buflisted)
