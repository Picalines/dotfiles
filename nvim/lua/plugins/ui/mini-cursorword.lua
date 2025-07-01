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
			vim.b[event.buf].minicursorword_disable = vim.bo[event.buf].buftype ~= ''
		end)

		require('mini.cursorword').setup(opts)
	end,
}
