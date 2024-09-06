return {
	'echasnovski/mini.cursorword',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		delay = 250,
	},

	config = function(_, opts)
		local autocmd = require 'util.autocmd'
		local hl = require 'util.highlight'

		require('mini.cursorword').setup(opts)

		hl.link('MiniCursorword', 'CursorLine')

		local function disable_mini_cursorword(event)
			vim.b[event.buf].minicursorword_disable = true
		end

		autocmd.on_filetype({
			'help',
			'lazy',
			'neo-tree',
			'neo-tree-popup',
			'neotest-output',
			'neotest-output-panel',
			'neotest-summary',
			'noice',
		}, disable_mini_cursorword)

		autocmd.on({ 'BufEnter' }, 'term://*', disable_mini_cursorword)
	end,
}
