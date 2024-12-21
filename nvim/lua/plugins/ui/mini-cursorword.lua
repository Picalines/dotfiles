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
			vim.api.nvim_buf_set_var(event.buf, 'minicursorword_disable', true)
		end

		local augroup = autocmd.group 'mini-cursorword'

		augroup:on('FileType', {
			'help',
			'lazy',
			'neo-tree',
			'neo-tree-popup',
			'neotest-output',
			'neotest-output-panel',
			'neotest-summary',
			'noice',
		}, disable_mini_cursorword)

		augroup:on({ 'BufEnter', 'TermOpen' }, 'term://*', disable_mini_cursorword)
	end,
}
