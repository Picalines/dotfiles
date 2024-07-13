local M = {}

function M.noop(...)
	return ...
end

function M.declare_keymaps(declaration)
	local base_opts = declaration.opts or {}
	declaration.opts = nil

	for section_key, keymaps in pairs(declaration) do
		local modes = {}
		local section_opts = {}

		if type(section_key) ~= 'table' then
			section_key = { section_key }
		end

		for opt_key, opt_value in pairs(section_key) do
			if type(opt_key) == 'string' then
				section_opts[opt_key] = opt_value
			else
				modes[opt_key] = opt_value
			end
		end

		for lhs, keymap in pairs(keymaps) do
			local rhs, map_opts

			if type(keymap) == 'table' then
				rhs = keymap[1]
				map_opts = keymap
				map_opts.desc = map_opts[2] or map_opts.desc
				map_opts[1] = nil
				map_opts[2] = nil
			else
				rhs = keymap
				map_opts = {}
			end

			local opts = vim.tbl_extend('force', base_opts, section_opts, map_opts)

			if type(lhs) ~= 'table' then
				lhs = { lhs }
			end

			for _, lhs_i in ipairs(lhs) do
				local ok = pcall(vim.keymap.set, modes, lhs_i, rhs, opts)
				if not ok then
					local lhs_s = tostring(lhs_i)
					local modes_s = table.concat(modes, ',')
					print('failed map `' .. lhs_s .. '` in ' .. modes_s)
				end
			end
		end
	end
end

function M.switch_app(funcs)
	for app, f in pairs(funcs) do
		if type(app) == 'table' then
			for _, iapp in ipairs(app) do
				funcs[iapp] = f
			end
		end
	end

	funcs.nvim = funcs.nvim or M.noop
	funcs.vscode = funcs.vscode or M.noop
	funcs.neovide = funcs.neovide or M.noop
	funcs.terminal = funcs.terminal or M.noop

	if vim.g.vscode then
		funcs.vscode()
	else
		funcs.nvim()

		if vim.g.neovide then
			funcs.neovide()
		else
			funcs.terminal()
		end
	end
end

---@param filetypes string | table<string>
function M.per_filetype(filetypes, callback)
	if type(filetypes) ~= 'table' then
		filetypes = { filetypes }
	end

	for _, filetype in pairs(filetypes) do
		vim.api.nvim_create_autocmd('BufWinEnter', {
			group = vim.api.nvim_create_augroup('per_filetype', { clear = false }),
			callback = function(opts)
				if vim.bo[opts.buf].filetype == filetype then
					callback(opts)
				end
			end,
		})
	end
end

function M.cmds(...)
	local cmds = { ... }
	return function()
		for _, cmd in pairs(cmds) do
			vim.cmd(cmd)
		end
	end
end

---@param value number
---@param min number
---@param max number
function M.clamp(value, min, max)
	if min > max then
		return M.clamp(value, max, min)
	end
	return math.max(min, math.min(max, value))
end

---@generic K, T, U
---@param tbl table<K, T>
---@param func fun(value: T, key: K): U
---@return table<K, U>
function M.map(tbl, func)
	local mapped_tbl = {}
	for k, v in pairs(tbl) do
		mapped_tbl[k] = func(v, k)
	end
	return mapped_tbl
end

---@param tbl table
---@param key any
---@param value any
local function set_or_push(tbl, key, value)
	if type(key) == 'number' then
		table.insert(tbl, value)
	else
		tbl[key] = value
	end
end

---@generic KS, KR, VS, VR
---@param tbl table<KS, VS>
---@param func fun(value: VS, key: KS): table<KR, VR>
---@return table<KR, VR>
function M.flat_map(tbl, func)
	local mapped_tbl = {}
	for k, v in pairs(tbl) do
		local t = func(v, k)
		for tk, tv in pairs(t) do
			set_or_push(mapped_tbl, tk, tv)
		end
	end
	return mapped_tbl
end

---@param tbl table
---@return table
function M.flatten(tbl)
	local flattened_tbl = {}
	for k, v in pairs(tbl) do
		if type(k) == 'number' and type(v) == 'table' then
			for kk, vv in pairs(v) do
				flattened_tbl[kk] = vv
			end
		else
			flattened_tbl[k] = v
		end
	end
	return flattened_tbl
end

---@generic K, T
---@param tbl table<K, T>
---@param keep_predicate fun(value: T, key: K): boolean
---@return table<K, T>
function M.filter(tbl, keep_predicate)
	local filtered_tbl = {}
	for k, v in pairs(tbl) do
		if keep_predicate(v, k) then
			set_or_push(filtered_tbl, k, v)
		end
	end
	return filtered_tbl
end

---@generic T
---@param value T
---@return T
function M.copy_deep(value)
	if type(value) ~= 'table' then
		return value
	end

	local copy = {}
	for k, v in pairs(value) do
		copy[k] = M.copy_deep(v)
	end

	return setmetatable(copy, getmetatable(value))
end

---@generic K, T
---@param ... table<K, T>
---@return table<K, T>
function M.override(...)
	return vim.tbl_extend('force', ...)
end

---@generic K, T
---@param ... table<K, T>
---@return table<K, T>
function M.override_deep(...)
	return vim.tbl_deep_extend('force', ...)
end

---@param ... table
---@return table
function M.join(...)
	local joined = {}
	for k, v in pairs { ... } do
		set_or_push(joined, k, v)
	end
	return joined
end

---@param array table
---@param separator any
---@return table
function M.separate(array, separator)
	if #array <= 1 then
		return array
	end

	local separated = {}
	for i = 1, #array - 1 do
		table.insert(separated, array[i])
		table.insert(separated, separator)
	end

	table.insert(separated, array[#array])
	return separated
end

---@generic T
---@param tbl table<any, T>
---@param value T
---@return boolean
function M.contains_value(tbl, value)
	for _, v in pairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

---(lua is not typescript, sorry)
---@generic Args, R
---@param func fun(...: Args): R
---@param ... Args
---@return fun(...: Args): R
function M.curry(func, ...)
	local curried = { ... }
	return function(...)
		return func(unpack(curried), ...)
	end
end

return M
