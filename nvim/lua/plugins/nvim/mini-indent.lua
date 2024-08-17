return {
	'echasnovski/mini.indentscope',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		draw = {
			delay = 1,
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

		symbol = '│',
	},

	config = function(_, opts)
		local hl = require 'util.highlight'
		local autocmd = require 'util.autocmd'

		require('mini.indentscope').setup(opts)

		hl.link('MiniIndentscopeSymbol', 'Whitespace')

		autocmd.per_filetype({ 'help', 'neo-tree', 'lazy' }, function(args)
			vim.b[args.buf].miniindentscope_disable = true
		end)
	end,
}
