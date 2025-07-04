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
				apply = 'gha',
				reset = 'ghr',
				textobject = 'ih',

				goto_first = '',
				goto_last = '',
				goto_prev = '[h',
				goto_next = ']h',
			},

			options = {
				wrap_goto = true,
			},
		}

		keymap {
			[{ 'n', desc = 'Hunk: %s' }] = {
				['gha'] = { 'vihgha', 'apply', remap = true },
				['ghd'] = { diff.toggle_overlay, 'diff' },
			},
		}
	end,
}
