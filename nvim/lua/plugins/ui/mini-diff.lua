return {
	'nvim-mini/mini.diff',

	init = function()
		local diff = require 'mini.diff'
		local keymap = require 'mappet'
		local map, sub = keymap.map, keymap.sub

		local keys = keymap.group 'plugins.ui.mini-diff'

		local function operator_expr(mode, textobject)
			return function()
				return diff.operator(mode) .. (textobject or '')
			end
		end

		keys 'Hunk: %s' {
			map('<LocalLeader>d', 'diff') { diff.toggle_overlay },

			sub { expr = true, remap = true } {
				map('<LocalLeader>ha', 'apply') { operator_expr('apply', 'ih') },
				map('<LocalLeader>hr', 'reset') { operator_expr('reset', 'ih') },

				sub { 'x' } {
					map('<LocalLeader>ha', 'apply') { operator_expr 'apply' },
					map('<LocalLeader>hr', 'reset') { operator_expr 'reset' },
				},
			},
		}
	end,

	opts = function()
		local diff = require 'mini.diff'

		return {
			source = {
				diff.gen_source.git(),
				diff.gen_source.save(),
			},

			view = {
				style = 'sign',
				-- different widths are intentional
				signs = { delete = '▍', add = '▍', change = '▌' },
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
	end,
}
