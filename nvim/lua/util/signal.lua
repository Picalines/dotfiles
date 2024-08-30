local array = require 'util.array'
local func = require 'util.func'

local M = {}

local observer_stack = {}

local function observe(x, fn)
	observer_stack[#observer_stack + 1] = x
	local result = fn()
	observer_stack[#observer_stack] = nil
	return result
end

---@generic T
---@param value_or_factory T | fun(): T
---@return fun(new_value_or_factory?: T | fun(): T): T
function M.new(value_or_factory)
	local _self = {}

	local _is_computed = false
	local _value, _factory
	local _subscribers = {}

	if type(value_or_factory) == 'function' then
		_factory = value_or_factory
	else
		_factory = func.const(value_or_factory)
		_value = value_or_factory
		_is_computed = true
	end

	local function make_dirty()
		_is_computed = false
	end

	local function read()
		if not _is_computed then
			_value = observe(_self, _factory)
			_is_computed = true
		end

		local observer = observer_stack[#observer_stack]
		if observer and not array.contains(_subscribers, observer) then
			if observer == _self then
				error 'recursive signal'
			end

			_subscribers[#_subscribers + 1] = observer
		end

		return _value
	end

	local function write(new_value_or_factory)
		local needs_update

		if type(new_value_or_factory) == 'function' then
			needs_update = true
			_factory = new_value_or_factory
			_is_computed = false
		else
			needs_update = _value ~= new_value_or_factory
			_value = new_value_or_factory
			_is_computed = true
		end

		if needs_update then
			for _, subscriber in ipairs(_subscribers) do
				subscriber._notify()
			end
		end

		return _value
	end

	local function on_called(_, ...)
		local args = { ... }
		if #args > 1 then
			error 'signal expects 0 or 1 arguments'
		end

		if #args == 1 then
			return write(args[1])
		end

		return read()
	end

	---@diagnostic disable-next-line: return-type-mismatch
	return setmetatable(_self, {
		__call = on_called,
		__index = {
			_notify = make_dirty,
		},
	})
end

---@param fn fun()
function M.watch(fn)
	local _self = {}

	local function run()
		observe(_self, fn)
	end

	run()

	return setmetatable(_self, {
		__index = {
			_notify = run,
		},
	})
end

return M
