local M = {}

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

--- (lua is not typescript, sorry)
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
