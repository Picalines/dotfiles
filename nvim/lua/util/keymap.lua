local tbl = require 'util.table'
local array = require 'util.array'

local M = {}

---@class keymap_info
---@field modes string[]
---@field opts table

---@param decl_table table
---@param _info? keymap_info
function M.declare(decl_table, _info)
	if _info == nil then
		_info = { modes = {}, opts = {} }
	end

	for key, value in pairs(decl_table) do
		if type(key) == 'string' then -- mapping
			local lhs = key
			local rhs, local_opts

			if type(value) == 'table' then
				rhs = value[1]
				local_opts = tbl.copy_deep(value)
				local_opts.desc = value.desc or value[2]
				local_opts[1] = nil
				local_opts[2] = nil
			else
				rhs = value
				local_opts = {}
			end

			local modes = _info.modes
			if #modes == 0 then
				modes = { 'n' }
			end

			local opts = tbl.override_deep(_info.opts, local_opts)

			local ok = pcall(vim.keymap.set, modes, lhs, rhs, opts)
			if not ok then
				print('keymap: failed to map`' .. lhs .. '`')
			end
		elseif type(key) == 'table' and type(value) == 'table' then
			local group_modes = {}
			local group_opts = {}

			for s_key, s_value in pairs(key) do
				if type(s_key) == 'number' then
					group_modes[#group_modes + 1] = s_value
				elseif type(s_key) == 'string' then
					group_opts[s_key] = s_value
				end
			end

			M.declare(value, {
				modes = array.concat(_info.modes, group_modes),
				opts = tbl.override_deep(_info.opts, group_opts),
			})
		end
	end
end

return M
