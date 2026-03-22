return {
	'nvim-mini/mini.diff',

	event = 'VeryLazy',

	config = function()
		local diff = require 'mini.diff'
		local keymap = require 'mappet'
		local map = keymap.map

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

		local keys = keymap.group 'plugins.ui.mini-diff'

		keys('Git: %s', { 'n' }) {
			map('<LocalLeader>d', 'diff') { diff.toggle_overlay },
		}
	end,
}
