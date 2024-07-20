return {
	'windwp/nvim-autopairs',

	event = 'InsertEnter',

	opts = {
		check_ts = true,
	},

	config = function(_, opts)
		local tbl = require 'util.table'
		local autopairs = require 'nvim-autopairs'
		local Rule = require 'nvim-autopairs.rule'

		autopairs.setup(opts)

		local function get_node_at_left()
			local cursor = vim.api.nvim_win_get_cursor(0)
			cursor[1] = cursor[1] - 1
			if cursor[2] > 0 then
				cursor[2] = cursor[2] - 1
			end

			return vim.treesitter.get_node { pos = cursor }
		end

		local function is_or_any_of(value, variants)
			if type(variants) ~= 'table' then
				variants = { variants }
			end

			return tbl.contains_value(variants, value)
		end

		local function is_inside_ts_node(node_types)
			return function()
				local node = get_node_at_left()

				while node ~= nil do
					for _, checked_type in ipairs(node_types) do
						if node:type() == checked_type then
							return true
						end
					end

					node = node:parent()
				end

				return false
			end
		end

		local function is_in_ts_tree(node_types)
			return function()
				local node = get_node_at_left()

				for i = #node_types, 1, -1 do
					if node == nil or not is_or_any_of(node:type(), node_types[i]) then
						return false
					end

					node = node:parent()
				end

				return true
			end
		end

		local function all_conds(...)
			local conds = { ... }
			return function(o)
				for _, cond in ipairs(conds) do
					if not cond(o) then
						return false
					end
				end

				return true
			end
		end

		local function any_cond(...)
			local conds = { ... }
			return function(o)
				for _, cond in ipairs(conds) do
					if cond(o) then
						return true
					end
				end

				return false
			end
		end

		local function not_cond(cond)
			return function(o)
				return not cond(o)
			end
		end

		autopairs.add_rules {
			Rule('<', '>', { 'typescript', 'typescriptreact' }):with_pair(
				all_conds(
					not_cond(is_in_ts_tree { 'string_fragment' }),
					not_cond(is_in_ts_tree { 'string' }),
					any_cond(
						is_in_ts_tree { 'type_identifier' },
						is_in_ts_tree { 'function_declaration', 'identifier' },
						is_in_ts_tree { 'call_expression', 'identifier' },
						is_in_ts_tree { 'call_expression', 'member_expression', 'property_identifier' },
						is_in_ts_tree { 'new_expression', 'identifier' },
						is_in_ts_tree { 'new_expression', 'member_expression', 'property_identifier' },
						is_inside_ts_node { 'type_alias_declaration', 'type_annotation', 'type_parameters', 'type_arguments' }
					)
				)
			),
		}
	end,
}
