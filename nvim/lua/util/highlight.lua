local func = require 'util.func'
local umath = require 'util.math'

local M = {}

---@class get_opts
---@field ns_id? integer
---@field follow_link? boolean
---@field fallback_hl? string

---@param hl_name string
---@param opts get_opts
function M.get(hl_name, opts)
	opts = func.default_opts(opts, {
		ns_id = 0,
		follow_link = true,
		fallback_hl = nil,
	})

	local hl = vim.api.nvim_get_hl(opts.ns_id, {
		name = hl_name,
		link = opts.follow_link,
		create = false,
	})

	if hl.link then
		return M.get(hl.link, opts)
	end

	if not next(hl) then
		if opts.fallback_hl and hl_name ~= opts.fallback_hl then
			return M.get(opts.fallback_hl, opts)
		else
			return nil
		end
	end

	return hl
end

---@class attr_opts
---@field ns_id? integer
---@field follow_link? boolean
---@field fallback_hl? string
---@field default_value? string

---@param hl_name string
---@param attribute 'fg' | 'bg'
---@param opts? attr_opts
function M.attr(hl_name, attribute, opts)
	opts = func.default_opts(opts, {
		ns_id = 0,
		follow_link = true,
		fallback_hl = 'Normal',
		default_value = nil,
	})

	local hl = M.get(hl_name, {
		ns_id = opts.ns_id,
		follow_link = opts.follow_link,
		fallback_hl = opts.fallback_hl,
	})

	if hl and hl[attribute] then
		return hl[attribute]
	end

	if opts.default_value ~= nil then
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
	opts = func.default_opts(opts, {
		ns_id = 0,
	})

	vim.api.nvim_set_hl(opts.ns_id, target_hl, { link = source_hl })
end

---@class clear_opts
---@field ns_id? integer

local clear_map = {
	fg = 'NONE',
	bg = 'NONE',
	sp = 'NONE',
	blend = 0,
	bold = false,
	standout = false,
	underline = false,
	underdouble = false,
	underdotted = false,
	underdashed = false,
	strikethrough = false,
	italic = false,
	reverse = false,
	nocombine = false,
}

---@param target_hl string
---@param attrs? string | string[]
---@param opts? clear_opts
function M.clear(target_hl, attrs, opts)
	opts = func.default_opts(opts, { ns_id = 0 })

	if not attrs or attrs == '*' then
		attrs = vim.tbl_keys(clear_map)
	end

	if type(attrs) ~= 'table' then
		attrs = { attrs }
	end

	local new_attrs = vim.iter(attrs):fold({}, function(acc, attr)
		acc[attr] = clear_map[attr]
		return acc
	end)

	local hl = M.get(target_hl, { ns_id = opts.ns_id, follow_link = true }) or {}

	---@diagnostic disable-next-line: param-type-mismatch
	vim.api.nvim_set_hl(opts.ns_id, target_hl, vim.tbl_deep_extend('force', hl, new_attrs))
end

---@param hex integer
local function hex_to_rgb(hex)
	hex = hex % 0x1000000
	local r = math.floor(hex / 0x10000) % 0x100
	local g = math.floor(hex / 0x100) % 0x100
	local b = hex % 0x100
	return r, g, b
end

---@param hex1 integer
---@param hex2 integer
---@param blend number
local function blend_hex(hex1, hex2, blend)
	blend = umath.clamp(blend, 0, 1)

	local r1, g1, b1 = hex_to_rgb(hex1)
	local r2, g2, b2 = hex_to_rgb(hex2)

	local r = umath.clamp(math.floor(umath.lerp(r1, r2, blend)), 0, 255)
	local g = umath.clamp(math.floor(umath.lerp(g1, g2, blend)), 0, 255)
	local b = umath.clamp(math.floor(umath.lerp(b1, b2, blend)), 0, 255)

	return r * 0x10000 + g * 0x100 + b
end

---@module 'util.autocmd'
---@param augroup AutocmdGroup
---@param source_hl string
---@param target_hl string
---@param opacity_factor number
---@param opts? get_opts
function M.fade(augroup, source_hl, target_hl, opacity_factor, opts)
	opts = func.default_opts(opts, {
		ns_id = 0,
		follow_link = true,
		fallback_hl = nil,
	})

	local function set_target_hl()
		local source_attrs = M.get(source_hl, opts)

		local target_attrs = {}
		if source_attrs then
			target_attrs = vim.tbl_extend('force', source_attrs, {
				fg = blend_hex(source_attrs.bg, source_attrs.fg, opacity_factor),
			})
		end

		vim.api.nvim_set_hl(opts.ns_id, target_hl, target_attrs)
	end

	augroup:on('ColorScheme', '*', set_target_hl)
	set_target_hl()
end

---@class on_background_map
---@field light string
---@field dark string

---@param augroup AutocmdGroup
---@param map on_background_map
function M.link_colorschemes_by_background(augroup, map)
	augroup:on(
		'ColorScheme',
		map.dark,
		vim.schedule_wrap(function()
			if vim.o.background == 'light' then
				vim.cmd.colorscheme(map.light)
			end
		end)
	)

	augroup:on(
		'ColorScheme',
		map.light,
		vim.schedule_wrap(function()
			if vim.o.background == 'dark' then
				vim.cmd.colorscheme(map.dark)
			end
		end)
	)
end

return M
