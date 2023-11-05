return {
	'nvim-treesitter/nvim-treesitter-textobjects',
	lazy = true,
	config = function()
		require('nvim-treesitter.configs').setup {
			textobjects = {
				select = {
					enable = true,

					lookahead = true,

					keymaps = {
						['as'] = '@statement.outer',

						['a='] = '@assignment.outer',
						['i='] = '@assignment.inner',
						['L='] = '@assignment.lhs',
						['R='] = '@assignment.rhs',

						['ar'] = '@return.outer',
						['ir'] = '@return.inner',

						['ap'] = '@property.outer',
						['ip'] = '@property.inner',
						['lp'] = '@property.lhs',
						['rp'] = '@property.rhs',

						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',

						['ai'] = '@conditional.outer',
						['ii'] = '@conditional.inner',

						['al'] = '@loop.outer',
						['il'] = '@loop.inner',

						['af'] = '@call.outer',
						['if'] = '@call.inner',

						['am'] = '@function.outer',
						['im'] = '@function.inner',

						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
					},
				},
				swap = {
					enable = true,
					swap_next = {
						['>s'] = '@statement.outer',
						['>a'] = '@parameter.inner',
						['>p'] = '@property.outer',
						['>m'] = '@function.outer',
						['>c'] = '@class.outer',
					},
					swap_previous = {
						['<s'] = '@statement.outer',
						['<a'] = '@parameter.inner',
						['<p'] = '@property.outer',
						['<m'] = '@function.outer',
						['<c'] = '@class.outer',
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						[']s'] = '@statement.outer',
						[']='] = '@assignment.outer',
						[']r'] = '@return.inner',
						[']f'] = '@call.outer',
						[']m'] = '@function.outer',
						[']c'] = '@class.outer',
						[']i'] = '@conditional.outer',
						[']l'] = '@loop.outer',
						[']a'] = '@parameter.inner',
						[']p'] = '@property.inner',

						[']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold start' },
					},
					goto_next_end = {
						[']S'] = '@statement.outer',
						[']+'] = '@assignment.outer',
						[']R'] = '@return.inner',
						[']F'] = '@call.outer',
						[']M'] = '@function.outer',
						[']C'] = '@class.outer',
						[']I'] = '@conditional.outer',
						[']L'] = '@loop.outer',
						[']A'] = '@parameter.inner',
						[']P'] = '@property.inner',

						[']Z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold end' },
					},
					goto_previous_start = {
						['[s'] = '@statement.outer',
						['[='] = '@assignment.outer',
						['[r'] = '@return.inner',
						['[f'] = '@call.outer',
						['[m'] = '@function.outer',
						['[c'] = '@class.outer',
						['[i'] = '@conditional.outer',
						['[l'] = '@loop.outer',
						['[a'] = '@parameter.inner',
						['[p'] = '@property.inner',

						['[z'] = { query = '@fold', query_group = 'folds', desc = 'Prev fold start' },
					},
					goto_previous_end = {
						['[S'] = '@statement.outer',
						['[+'] = '@assignment.outer',
						['[R'] = '@return.inner',
						['[F'] = '@call.outer',
						['[M'] = '@function.outer',
						['[C'] = '@class.outer',
						['[I'] = '@conditional.outer',
						['[L'] = '@loop.outer',
						['[A'] = '@parameter.inner',
						['[P'] = '@property.inner',

						['[Z'] = { query = '@fold', query_group = 'folds', desc = 'Prev fold end' },
					},
				},
			},
		}

		local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

		require('keymaps.util').declare_keymaps {
			[{ 'n', 'x', 'o' }] = {
				-- vim way: ; goes to the direction you were moving.
				[';'] = ts_repeat_move.repeat_last_move,
				[','] = ts_repeat_move.repeat_last_move_opposite,

				-- Optionally, make builtin f, F, t, T also repeatable with ; and ,,
				['f'] = ts_repeat_move.builtin_f,
				['F'] = ts_repeat_move.builtin_F,
				['t'] = ts_repeat_move.builtin_t,
				['T'] = ts_repeat_move.builtin_T,
			},
		}
	end,
}
