local app = require 'util.app'
local tbl = require 'util.table'

---@class keymap_info
---@field modes string[]
---@field opts table

---@param decl_table table
---@param _info? keymap_info
local function keymap(decl_table, _info)
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

			local group_desc = _info.opts.desc
			local opts = tbl.override_deep(_info.opts, local_opts)

			if type(group_desc) == 'string' and local_opts.desc then
				---@diagnostic disable-next-line: inject-field
				opts.desc = string.format(group_desc, local_opts.desc)
			end

			local ok = pcall(vim.keymap.set, modes, lhs, rhs, opts)
			if not ok then
				vim.notify(string.format('keymap: failed to map `%s`', lhs), vim.log.levels.ERROR)
			end
		elseif type(key) == 'table' and type(value) == 'table' then
			local group_modes = {}
			local group_opts = {}

			for s_key, s_value in pairs(key) do
				if type(s_key) == 'number' then
					group_modes[#group_modes + 1] = s_value
				elseif s_key == 'client' then
					if app.client() ~= s_value then
						return
					end
				elseif s_key == 'os' then
					if app.os() ~= s_value then
						return
					end
				else
					group_opts[s_key] = s_value
				end
			end

			local inner_modes = {}
			vim.list_extend(inner_modes, _info.modes)
			vim.list_extend(inner_modes, group_modes)

			keymap(value, {
				modes = inner_modes,
				opts = tbl.override_deep(_info.opts, group_opts),
			})
		end
	end
end

return keymap
