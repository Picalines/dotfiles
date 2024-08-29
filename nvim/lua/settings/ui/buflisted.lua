local autocmd = require 'util.autocmd'

local function disable_buflisted(event)
	vim.api.nvim_set_option_value('buflisted', false, { buf = event.buf })
end

autocmd.on_filetype({ 'qf' }, disable_buflisted)
autocmd.on('TermOpen', '*', disable_buflisted)
