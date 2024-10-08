return {
	'echasnovski/mini.indentscope',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		draw = {
			delay = 1,
			priority = 10,
		},

		mappings = {
			object_scope = 'ii',
			object_scope_with_border = 'ai',

			goto_top = '[i',
			goto_bottom = ']i',
		},

		options = {
			border = 'both',

			indent_at_cursor = true,

			try_as_border = true,
		},

		symbol = '┃',
	},

	config = function(_, opts)
		local hl = require 'util.highlight'
		local autocmd = require 'util.autocmd'

		require('mini.indentscope').setup(opts)

		hl.link('MiniIndentscopeSymbol', 'Whitespace')

		local function disable_mini_indentscope(event)
			vim.api.nvim_buf_set_var(event.buf, 'miniindentscope_disable', true)
		end

		autocmd.on_filetype({
			'help',
			'lazy',
			'messages',
			'neo-tree',
			'neo-tree-popup',
			'neotest-output',
			'neotest-output-panel',
			'neotest-summary',
			'noice',
		}, disable_mini_indentscope)

		autocmd.on({ 'BufEnter', 'TermOpen' }, 'term://*', disable_mini_indentscope)
	end,
}
