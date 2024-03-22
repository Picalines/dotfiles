local M = {}

function M.noop(...)
	return ...
end

function M.declare_keymaps(declaration)
	local base_opts = declaration.opts or {}
	declaration.opts = nil

	for mode, keymaps in pairs(declaration) do
		for lhs, keymap in pairs(keymaps) do
			local rhs, opts

			if type(keymap) == 'table' then
				rhs = keymap[1]
				opts = keymap
				opts.desc = opts[2] or opts.desc
				opts[1] = nil
				opts[2] = nil
			else
				rhs = keymap
				opts = {}
			end

			opts = vim.tbl_extend('force', base_opts, opts)

			vim.keymap.set(mode, lhs, rhs, opts)
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
