local M = {}

---@class get_opts
---@field ns_id? integer
---@field follow_link? boolean
---@field fallback_hl? string

---@param hl_name string
---@param opts get_opts
function M.get(hl_name, opts)
	opts = vim.tbl_deep_extend('keep', opts, {
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

---@class link_opts
---@field ns_id? integer

---@param target_hl string
---@param source_hl string
---@param opts? link_opts
function M.link(target_hl, source_hl, opts)
	opts = vim.tbl_deep_extend('keep', opts or {}, { ns_id = 0 })

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
	opts = vim.tbl_deep_extend('keep', opts or {}, { ns_id = 0 })

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

---@class picked_opts
---@field ns_id? integer
---@field follow_link? boolean

---@param augroup AutocmdGroup
---@param target_hl string
---@param attrs? table<string, string> {attr: hl}
---@param opts? picked_opts
function M.pick(augroup, target_hl, attrs, opts)
	opts = vim.tbl_deep_extend('keep', opts or {}, {
		ns_id = 0,
		follow_link = true,
	})

	local function init_colorscheme()
		local target_attrs = vim.iter(attrs):fold({}, function(acc, attr, source_hl)
			local source_attrs = M.get(source_hl, { ns_id = opts.ns_id, follow_link = opts.follow_link })
			if source_attrs and source_attrs[attr] then
				acc[attr] = source_attrs[attr]
			end
			return acc
		end)

		vim.api.nvim_set_hl(opts.ns_id, target_hl, target_attrs)
	end

	augroup:on_user('ColorSchemeInit', init_colorscheme)
	init_colorscheme()
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
