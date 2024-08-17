local tbl = require 'util.table'

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

---@generic T
---@param opts_arg T | nil
---@param defaults T
---@return T
function M.default_opts(opts_arg, defaults)
	if opts_arg == nil then
		return defaults
	end

	return tbl.override_deep(defaults, opts_arg)
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

---@generic O, R
---@param func fun(opts: O): R
---@param opts table
---@return fun(opts: O): R
function M.curry_opts(func, opts)
	return function(p_opts)
		return func(tbl.override_deep(opts, p_opts or {}))
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

---@generic T
---@param x T
---@return fun(...): T
function M.const(x)
	return function()
		return x
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
