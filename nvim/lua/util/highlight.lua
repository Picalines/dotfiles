local func_util = require 'util.func'

local default = func_util.default

local M = {}

---@class hl_attr_opts
---@field follow_link? boolean
---@field fallback_hl? string
---@field default_value? string
---@field _rec_depth? number

---@param hl_name string
---@param attribute 'fg' | 'bg'
---@param opts? hl_attr_opts
function M.hl_attr(hl_name, attribute, opts)
	if opts == nil then
		opts = { _rec_depth = 0 }
	else
		opts._rec_depth = default(opts._rec_depth, 0) + 1
	end

	local hl = vim.api.nvim_get_hl(0, {
		name = hl_name,
		link = default(opts.follow_link, true),
		create = false,
	})

	if hl.link then
		return M.hl_attr(hl.link, attribute, opts)
	end

	if hl[attribute] then
		return hl[attribute]
	end

	local fallback_hl = default(opts.fallback_hl, 'Normal')

	if hl_name ~= fallback_hl then
		return M.hl_attr(fallback_hl, attribute, opts)
	elseif opts.default_value ~= nil then
		return opts.default_value
	elseif vim.o.background == 'dark' then
		return attribute == 'fg' and 'white' or 'NONE'
	else
		return attribute == 'fg' and 'black' or 'NONE'
	end
end

return M
