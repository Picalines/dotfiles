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

		local augroup = autocmd.group 'mini-indent'

		augroup:on({ 'BufEnter', 'TermOpen' }, '*', function(event)
			local buftype = vim.api.nvim_get_option_value('buftype', { buf = event.buf })
			if buftype ~= '' then
				disable_mini_indentscope(event)
			end
		end)
	end,
}
