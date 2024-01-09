return {
	'nvim-treesitter/nvim-treesitter-textobjects',

	event = 'VeryLazy',

	config = function()
		local util = require 'util'
		local flatten = util.flatten
		local flat_map = util.flat_map

		local function declare_select(part_keys, declarations)
			return {
				enable = true,
				lookahead = true,
				keymaps = flat_map(declarations, function(declaration, obj_key)
					local obj_name = declaration[1]
					local obj_parts = declaration[2]
					return flat_map(obj_parts, function(part)
						local keymap = part_keys[part] .. obj_key
						local capture_group = obj_name .. '.' .. part
						return { [keymap] = capture_group }
					end)
				end),
			}
		end

		local function declare_swap(swap_keys, declarations)
			return flatten {
				enable = true,
				flat_map({ 'next', 'previous' }, function(dir)
					return {
						['swap_' .. dir] = flat_map(declarations, function(capture_group, obj_key)
							return { [swap_keys[dir] .. obj_key] = capture_group }
						end),
					}
				end),
			}
		end

		local function declare_move(jump_keys, declarations)
			return flatten {
				enable = true,
				set_jumps = true,
				flat_map({ 'next', 'previous' }, function(dir)
					return flat_map({ 'start', 'end' }, function(range, range_i)
						return {
							['goto_' .. dir .. '_' .. range] = flat_map(declarations, function(capture_group, obj_keys)
								return { [jump_keys[dir] .. obj_keys[range_i]] = capture_group }
							end),
						}
					end)
				end),
			}
		end

		require('nvim-treesitter.configs').setup {
			textobjects = {
				select = declare_select({ outer = 'a', inner = 'i', lhs = '(', rhs = ')' }, {
					['='] = { '@assignment', { 'outer', 'inner', 'lhs', 'rhs' } },
					['r'] = { '@return', { 'outer', 'inner' } },
					['p'] = { '@property', { 'outer', 'inner', 'lhs', 'rhs' } },
					['a'] = { '@parameter', { 'outer', 'inner' } },
					['i'] = { '@conditional', { 'outer', 'inner' } },
					['l'] = { '@loop', { 'outer', 'inner' } },
					['f'] = { '@call', { 'outer', 'inner' } },
					['m'] = { '@function', { 'outer', 'inner' } },
					['c'] = { '@class', { 'outer', 'inner' } },
				}),
				swap = declare_swap({ next = '>', previous = '<' }, {
					['a'] = '@parameter.inner',
					['p'] = '@property.outer',
					['m'] = '@function.outer',
					['c'] = '@class.outer',
				}),
				move = declare_move({ next = ']', previous = '[' }, {
					[{ '=', '+' }] = '@assignment.outer',
					[{ 'r', 'R' }] = '@return.inner',
					[{ 'f', 'F' }] = '@call.outer',
					[{ 'm', 'M' }] = '@function.outer',
					[{ 'c', 'C' }] = '@class.outer',
					[{ 'i', 'I' }] = '@conditional.outer',
					[{ 'l', 'L' }] = '@loop.outer',
					[{ 'a', 'A' }] = '@parameter.inner',
					[{ 'p', 'P' }] = '@property.inner',
				}),
			},
		}

		local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

		require('util').declare_keymaps {
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
