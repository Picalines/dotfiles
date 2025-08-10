return {
	'echasnovski/mini.diff',

	event = 'VeryLazy',

	config = function()
		local diff = require 'mini.diff'
		local keymap = require 'util.keymap'

		diff.setup {
			source = {
				diff.gen_source.git(),
				diff.gen_source.save(),
			},

			view = {
				style = 'sign',
				signs = { add = '+', change = '~', delete = '-' },
			},

			mappings = {
				textobject = 'ih',
				goto_prev = '[h',
				goto_next = ']h',
				apply = '',
				reset = '',
				goto_first = '',
				goto_last = '',
			},

			options = {
				wrap_goto = true,
			},
		}

		keymap {
			[{ 'n', desc = 'Git: %s' }] = {
				['<leader>gd'] = { diff.toggle_overlay, 'diff' },
			},
		}
	end,
}
