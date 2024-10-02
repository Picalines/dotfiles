local array = require 'util.array'
local func = require 'util.func'
local persist = require 'util.persist'

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
		if select('#', ...) >= 1 then
			return write(select(1, ...))
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

---@param signals (fun(): any) | (fun(): any)[]
---@param fn fun()
function M.on(signals, fn)
	if #signals == 0 then
		signals = { signals }
	end

	return M.watch(function()
		---@diagnostic disable-next-line: param-type-mismatch
		for _, signal in ipairs(signals) do
			signal()
		end

		fn()
	end)
end

---@generic T
---@param signal fun(new_value_or_factory?: T | fun(): T): T
---@param name string
---@return T
function M.persist(signal, name)
	local value = persist.get_item(name, signal())

	signal(value)

	M.watch(function()
		persist.save_item(name, signal())
	end)

	return value
end

return M
