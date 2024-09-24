return {
	'echasnovski/mini.ai',

	event = { 'BufReadPre', 'BufNewFile' },

	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},

	config = function()
		local mini_ai = require 'mini.ai'

		local spec_treesitter = mini_ai.gen_spec.treesitter

		mini_ai.setup {
			n_lines = 50,

			search_method = 'cover_or_next',

			silent = true,

			mappings = {
				around = 'a',
				inside = 'i',

				around_next = '',
				inside_next = '',
				around_last = '',
				inside_last = '',

				goto_left = 'g[',
				goto_right = 'g]',
			},

			custom_textobjects = {
				a = spec_treesitter { a = '@parameter.outer', i = '@parameter.inner' },
				f = spec_treesitter { a = '@call.outer', i = '@call.inner' },
				F = spec_treesitter { a = '@function.outer', i = '@function.inner' },
			},
		}
	end,
}
