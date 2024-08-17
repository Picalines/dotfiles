return {
	'nvim-treesitter/nvim-treesitter-textobjects',

	event = { 'BufReadPre', 'BufNewFile' },

	config = function()
		local tbl = require 'util.table'

		local function declare_select(part_keys, declarations)
			return {
				enable = true,
				lookahead = true,
				keymaps = tbl.flat_map(declarations, function(obj_key, declaration)
					local obj_name = declaration[1]
					local obj_parts = declaration[2]
					return tbl.flat_map(obj_parts, function(_, part)
						local map = part_keys[part] .. obj_key
						local capture_group = obj_name .. '.' .. part
						return { [map] = capture_group }
					end)
				end),
			}
		end

		local function declare_swap(swap_keys, declarations)
			return tbl.flatten {
				enable = true,
				tbl.flat_map({ 'next', 'previous' }, function(_, dir)
					return {
						['swap_' .. dir] = tbl.flat_map(declarations, function(obj_key, capture_group)
							return { [swap_keys[dir] .. obj_key] = capture_group }
						end),
					}
				end),
			}
		end

		local function declare_move(jump_keys, declarations)
			return tbl.flatten {
				enable = true,
				set_jumps = true,
				tbl.flat_map({ 'next', 'previous' }, function(_, dir)
					return tbl.flat_map({ 'start', 'end' }, function(range_i, range)
						return {
							['goto_' .. dir .. '_' .. range] = tbl.flat_map(declarations, function(obj_keys, capture_group)
								return { [jump_keys[dir] .. obj_keys[range_i]] = capture_group }
							end),
						}
					end)
				end),
			}
		end

		---@diagnostic disable-next-line: missing-fields
		require('nvim-treesitter.configs').setup {
			textobjects = {
				select = declare_select({ outer = 'a', inner = 'i', lhs = '(', rhs = ')' }, {
					['='] = { '@assignment', { 'outer', 'inner', 'lhs', 'rhs' } },
					['r'] = { '@return', { 'outer', 'inner' } },
					['p'] = { '@property', { 'outer', 'inner', 'lhs', 'rhs' } },
					['a'] = { '@parameter', { 'outer', 'inner' } },
					['?'] = { '@conditional', { 'outer', 'inner' } },
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
					-- [{ 'i', 'I' }] = '@conditional.outer',
					[{ 'l', 'L' }] = '@loop.outer',
					[{ 'a', 'A' }] = '@parameter.inner',
					[{ 'p', 'P' }] = '@property.inner',
				}),
			},
		}
	end,
}
