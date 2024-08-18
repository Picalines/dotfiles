local autocmd = require 'util.autocmd'

local function disable_buflisted(event)
	vim.api.nvim_set_option_value('buflisted', false, { buf = event.buf })
end

autocmd.per_filetype({ 'qf' }, disable_buflisted)
autocmd.on_terminal_open(disable_buflisted)
