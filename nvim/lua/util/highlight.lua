local func_util = require 'util.func'

local default_opts = func_util.default_opts

local M = {}

---@class hl_attr_opts
---@field follow_link? boolean
---@field fallback_hl? string
---@field default_value? string
---@field _rec_depth? number

---@param hl_name string
---@param attribute 'fg' | 'bg'
---@param opts? hl_attr_opts
function M.attr(hl_name, attribute, opts)
	opts = default_opts(opts, {
		_rec_depth = 0,
		follow_link = true,
		fallback_hl = 'Normal',
		default_value = nil,
	})

	opts._rec_depth = opts._rec_depth + 1

	local hl = vim.api.nvim_get_hl(0, {
		name = hl_name,
		link = opts.follow_link,
		create = false,
	})

	if hl.link then
		return M.attr(hl.link, attribute, opts)
	end

	if hl[attribute] then
		return hl[attribute]
	end

	local fallback_hl = opts.fallback_hl --[[@as string]]

	if hl_name ~= fallback_hl then
		return M.attr(fallback_hl, attribute, opts)
	elseif opts.default_value ~= nil then
		return opts.default_value
	elseif vim.o.background == 'dark' then
		return attribute == 'fg' and 'white' or 'NONE'
	else
		return attribute == 'fg' and 'black' or 'NONE'
	end
end

---@class link_opts
---@field ns_id? integer

---@param target_hl string
---@param source_hl string
---@param opts? link_opts
function M.link(target_hl, source_hl, opts)
	opts = default_opts(opts, {
		ns_id = 0,
	})

	vim.api.nvim_set_hl(opts.ns_id, target_hl, { link = source_hl })
end

---@class clear_opts
---@field ns_id? integer

---@param target_hl string
---@param attrs? 'bg' | 'fg' | 'all'
---@param opts? clear_opts
function M.clear(target_hl, attrs, opts)
	opts = default_opts(opts, {
		ns_id = 0,
	})

	local new_attrs
	if attrs == 'fg' then
		new_attrs = { fg = 'NONE' }
	elseif attrs == 'bg' then
		new_attrs = { bg = 'NONE' }
	else
		new_attrs = {}
	end

	vim.api.nvim_set_hl(opts.ns_id, target_hl, new_attrs)
end

return M
