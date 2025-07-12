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

---@generic Args, R
---@param func fun(...: Args): R
---@return fun(...: Args): R
function M.pcalled(func)
	return function(...)
		return pcall(func, ...)
	end
end

---(lua is not typescript, sorry)
---@generic Args, R
---@param func fun(...: Args): R
---@param ... Args
---@return fun(...: Args): R
function M.curry(func, ...)
	local curried = { ... }
	return function(...)
		return func(unpack(vim.iter({ curried, { ... } }):flatten():totable()))
	end
end

---@generic Args, R
---@param func fun(...: Args): R
---@param ... Args
---@return fun(...: Args): R
function M.curry_only(func, ...)
	local curried = { ... }
	return function()
		return func(unpack(curried))
	end
end

---@generic Args, R
---@param func fun(...: Args): R
---@return fun(...: Args): R
function M.memo(func)
	local hashes_map = {}
	local cached_values = {}
	return function(...)
		local args_hash = vim.inspect { ... }
		if hashes_map[args_hash] then
			return unpack(cached_values[args_hash])
		end

		local values = { func(...) }

		hashes_map[args_hash] = true
		cached_values[args_hash] = values

		return unpack(values)
	end
end

---@param func fun(): any
---@return fun()
function M.ignore(func)
	return function()
		func()
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

---@param timeout integer
---@param callback fun()
---@return fun() cancel
function M.wait(timeout, callback)
	local timer = vim.loop.new_timer()

	timer:start(timeout, 0, function()
		timer:stop()
		timer:close()
		vim.schedule(callback)
	end)

	return function()
		timer:stop()
	end
end

---@param timeout integer
---@param fn fun()
function M.debounce(timeout, fn)
	local timer = vim.uv.new_timer() or error 'new_timer failed'

	return function(...)
		local fn_args = { ... }
		timer:stop()
		timer:start(
			timeout,
			0,
			vim.schedule_wrap(function()
				fn(unpack(fn_args))
			end)
		)
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

---@param key any
---@return fun(x: table): any
function M.field(key)
	return function(x)
		return x[key]
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
