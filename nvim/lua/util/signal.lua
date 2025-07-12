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
---@param initial_value T
---@return fun(new_value?: T): T
function M.new(initial_value)
	local _value = initial_value
	local _subscribers = {}

	local function read()
		local observer = observer_stack[#observer_stack]
		if observer and not vim.list_contains(_subscribers, observer) then
			_subscribers[#_subscribers + 1] = observer
		end

		return _value
	end

	local function write(new_value)
		local changed = _value ~= new_value

		_value = new_value

		if changed then
			for _, subscriber in ipairs(_subscribers) do
				subscriber._notify()
			end
		end

		return _value
	end

	return function(...)
		if select('#', ...) >= 1 then
			return write(select(1, ...))
		end

		return read()
	end
end

---@generic T
---@param factory fun(): T
---@return fun(): T
function M.derive(factory)
	local _self = {}

	local _value = nil
	local _is_computed = false
	local _subscribers = {}

	local function make_dirty()
		_is_computed = false
		_value = nil

		for _, subscriber in ipairs(_subscribers) do
			subscriber._notify()
		end
	end

	local function read()
		if not _is_computed then
			_value = observe(_self, factory)
			_is_computed = true
		end

		local observer = observer_stack[#observer_stack]
		if observer and not vim.list_contains(_subscribers, observer) then
			if observer == _self then
				error 'recursive signal'
			end

			_subscribers[#_subscribers + 1] = observer
		end

		return _value
	end

	local function on_called(_, ...)
		if select('#', ...) > 0 then
			error 'cannot write to a derived signal'
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

---@param signals (fun()) | (fun()[])
---@param fn fun()
function M.on(signals, fn)
	if type(signals) ~= 'table' then
		signals = { signals }
	end

	return M.watch(function()
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
