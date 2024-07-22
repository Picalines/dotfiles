local M = {}

function M.noop(...)
	return ...
end

---@generic T
---@param value T | nil
---@param default T
---@return T
function M.default(value, default)
	if value == nil then
		return default
	end

	return value
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

---@param ... string
---@return fun(): nil
function M.cmd(...)
	local cmds = { ... }

	return function()
		for _, cmd in pairs(cmds) do
			vim.cmd(cmd)
		end
	end
end

---@param threshold number
---@return fun(x: number): boolean
function M.greater_than(threshold)
	return function(x)
		return x > threshold
	end
end

---@param threshold number
---@return fun(x: number): boolean
function M.less_than(threshold)
	return function(x)
		return x < threshold
	end
end

return M
