local M = {}

---@generic T
---@param value T
---@param length integer
---@return T[]
function M.fill(value, length)
	local array = {}
	for i = 1, length do
		array[i] = value
	end
	return array
end

---@generic T
---@param length integer
---@param gen fun(index: integer): T
---@return T[]
function M.generate(length, gen)
	local array = {}
	for i = 1, length do
		array[i] = gen(i)
	end
	return array
end

---@generic T
---@param array T[]
---@return T[]
function M.copy(array)
	local array_copy = {}
	for _, item in ipairs(array) do
		array_copy[#array_copy + 1] = item
	end
	return array_copy
end

---@param array Array
---@return Array
function M.copy_deep(array)
	local array_copy = {}
	for _, item in ipairs(array) do
		if type(item) == 'table' then
			item = M.copy_deep(item)
		end
		array_copy[#array_copy + 1] = item
	end
	return array_copy
end

---@param array Array
---@return integer[]
function M.indices(array)
	local indices = {}
	for i, _ in ipairs(array) do
		indices[#indices + 1] = i
	end
	return indices
end

---@param array Array
---@return integer[]
function M.values(array)
	local values = {}
	for _, value in ipairs(array) do
		values[#values + 1] = value
	end
	return values
end

---@generic T
---@param array T[]
---@param predicate fun(value: T, index: integer): boolean
---@return T | nil
function M.find_value(array, predicate)
	for index, value in ipairs(array) do
		if predicate(value, index) then
			return value
		end
	end
end

---@generic T
---@param array T[]
---@param predicate fun(value: T, index: integer): boolean
---@return integer | nil
function M.find_index(array, predicate)
	for index, value in ipairs(array) do
		if predicate(value, index) then
			return index
		end
	end
end

---@param array Array
---@param value any
---@return boolean
function M.contains(array, value)
	for _, v in ipairs(array) do
		if v == value then
			return true
		end
	end
	return false
end

---@generic T
---@param array T[]
---@param predicate fun(value: T, index: integer): boolean
---@return boolean
function M.some(array, predicate)
	for index, value in ipairs(array) do
		if predicate(value, index) then
			return true
		end
	end
	return false
end

---@generic T
---@param array T[]
---@param predicate fun(value: T, index: integer): boolean
---@return boolean
function M.every(array, predicate)
	for index, value in ipairs(array) do
		if not predicate(value, index) then
			return false
		end
	end
	return true
end

---@generic T, U
---@param array T[]
---@param map fun(item: T, index: integer, array: T[]): U
---@return U[]
function M.map(array, map)
	local mapped = {}
	for index, item in ipairs(array) do
		mapped[#mapped + 1] = map(item, index, array)
	end
	return mapped
end

---@generic T, U
---@param map fun(item: T, index: integer, array: T[]): U[]
---@return U[]
function M.flat_map(array, map)
	local mapped = {}
	for index, item in ipairs(array) do
		for _, mapped_item in ipairs(map(item, index, array)) do
			mapped[#mapped + 1] = mapped_item
		end
	end
	return mapped
end

---@generic T
---@param array T[]
---@param keep fun(value: T, index: integer): boolean
---@return T[]
function M.filter(array, keep)
	local filtered = {}
	for index, value in ipairs(array) do
		if keep(value, index) then
			filtered[#filtered + 1] = value
		end
	end
	return filtered
end

---@generic T
---@param ... T[]
---@return T[]
function M.concat(...)
	local whole_array = {}
	for _, array in ipairs { ... } do
		for _, value in ipairs(array) do
			whole_array[#whole_array + 1] = value
		end
	end
	return whole_array
end

---@generic T
---@param array T[]
---@param max_length integer
---@return T[]
function M.take(array, max_length)
	local array_part = {}
	for i = 1, math.min(#array, max_length) do
		array_part[i] = array[i]
	end
	return array_part
end

---@generic T, S
---@param array T[]
---@param separator S
---@return (T | S)[]
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

return M
