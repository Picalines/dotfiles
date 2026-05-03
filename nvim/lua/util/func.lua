local M = {}

---(lua is not typescript, sorry)
---@generic Args, R
---@param func fun(...: Args): R
---@param ... Args
---@return fun(...: Args): R
function M.partial(func, ...)
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

---@param global_key string
---@param func fun()
function M.once(global_key, func)
	if vim.g[global_key] then
		return
	end

	func()
	vim.g[global_key] = true
end

---@generic Args
---@param timeout integer
---@param fn fun(...: Args)
---@return fun(...: Args)
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

return M
