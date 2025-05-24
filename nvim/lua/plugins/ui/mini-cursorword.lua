return {
	'echasnovski/mini.cursorword',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		delay = 250,
	},

	config = function(_, opts)
		local autocmd = require 'util.autocmd'
		local hl = require 'util.highlight'

		hl.link('MiniCursorword', 'CursorLine')

		local augroup = autocmd.group 'mini-cursorword'

		augroup:on({ 'BufEnter', 'TermOpen' }, '*', function(event)
			local buftype = vim.api.nvim_get_option_value('buftype', { buf = event.buf })
			vim.api.nvim_buf_set_var(event.buf, 'minicursorword_disable', buftype ~= '')
		end)

		require('mini.cursorword').setup(opts)
	end,
}
