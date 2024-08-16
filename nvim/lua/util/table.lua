local M = {}

---@generic K, T
---@param length integer
---@param func fun(index: integer): K, T
---@return table<K, T>
function M.generate(length, func)
	local tbl = {}
	for i = 1, length do
		local key, value = func(i)
		tbl[key] = value
	end
	return tbl
end

---@generic T
---@param value T
---@return T
function M.copy(value)
	if type(value) ~= 'table' then
		return value
	end

	local copy = {}
	for k, v in pairs(value) do
		copy[k] = v
	end

	return setmetatable(copy, getmetatable(value))
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

---@generic K
---@param tbl table<K, any>
---@return K[]
function M.keys(tbl)
	local keys = {}
	for key, _ in pairs(tbl) do
		table.insert(keys, key)
	end
	return keys
end

---@generic V
---@param tbl table<any, V>
---@return V[]
function M.values(tbl)
	local values = {}
	for _, value in pairs(tbl) do
		table.insert(values, value)
	end
	return values
end

---@generic K, T
---@param table table<K, T>
---@param predicate fun(key: K, value: T): boolean
---@return K | nil, T | nil
function M.find(table, predicate)
	for key, value in pairs(table) do
		if predicate(key, value) then
			return key, value
		end
	end

	return nil, nil
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

---@generic K, T, KF, TF
---@param tbl table<K, T>
---@param func fun(key: K, value: T): KF, TF
---@return table<KF, TF>
function M.map(tbl, func)
	local mapped_tbl = {}
	for key, value in pairs(tbl) do
		local m_key, m_value = func(key, value)
		mapped_tbl[m_key] = m_value
	end
	return mapped_tbl
end

---@generic KS, KR, VS, VR
---@param tbl table<KS, VS>
---@param func fun(key: KS, value: VS): table<KR, VR>
---@return table<KR, VR>
function M.flat_map(tbl, func)
	local mapped_tbl = {}
	for key, value in pairs(tbl) do
		for m_key, m_value in pairs(func(key, value)) do
			mapped_tbl[m_key] = m_value
		end
	end
	return mapped_tbl
end

---@param tbl table
---@return table
function M.flatten(tbl)
	local flattened_tbl = {}
	for key, value in pairs(tbl) do
		if type(key) == 'number' and type(value) == 'table' then
			for i_key, i_value in pairs(value) do
				flattened_tbl[i_key] = i_value
			end
		else
			flattened_tbl[key] = value
		end
	end
	return flattened_tbl
end

---@generic K, T
---@param tbl table<K, T>
---@param keep_predicate fun(key: K, value: T): boolean
---@return table<K, T>
function M.filter(tbl, keep_predicate)
	local filtered = {}
	for key, value in pairs(tbl) do
		if keep_predicate(key, value) then
			filtered[key] = value
		end
	end
	return filtered
end

---@generic K, V
---@param table table<K, V>
---@return table<V, integer>
function M.count_values(table)
	local counts = {}
	for _, value in pairs(table) do
		counts[value] = (counts[value] or 0) + 1
	end
	return counts
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

---@generic K, V
---@param tbl table<K, V>
---@return table<V, K[]>
function M.inverse(tbl)
	local inversed = {}
	for k, v in pairs(tbl) do
		inversed[v] = inversed[v] or {}
		table.insert(inversed[v], k)
	end
	return inversed
end

return M
