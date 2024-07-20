local M = {}

---@generic K, T
---@param table table<K, T>
---@param predicate fun(value: T, key: K): boolean
---@return K | nil, T | nil
function M.find(table, predicate)
	for key, value in pairs(table) do
		if predicate(value, key) then
			return key, value
		end
	end

	return nil, nil
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
function M.set_or_insert(tbl, key, value)
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
			M.set_or_insert(mapped_tbl, tk, tv)
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
			M.set_or_insert(filtered_tbl, k, v)
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
	for _, tbl in pairs { ... } do
		for k, v in pairs(tbl) do
			M.set_or_insert(joined, k, v)
		end
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

return M
