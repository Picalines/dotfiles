local io = require 'io'

local M = {}

---@diagnostic disable-next-line: param-type-mismatch
local PERSIST_PATH = vim.fs.joinpath(vim.fn.stdpath 'data', 'persist.json')

M._storage = {}

function M.load()
	local file = io.open(PERSIST_PATH, 'r')
	if not file then
		M._storage = {}
		return
	end

	M._storage = vim.json.decode(file:read '*a')
	file:close()
end

function M.save()
	local file = io.open(PERSIST_PATH, 'w+')
	if not file then
		print(PERSIST_PATH .. ': failed to write')
		return
	end

	file:write(vim.json.encode(M._storage))
	file:close()
end

---@generic T
---@param key string
---@param default T
---@return T
function M.get_item(key, default)
	local stored_value = M._storage[key]
	if type(default) == type(stored_value) then
		return stored_value
	end

	return default
end

---@param key string
---@param value any
function M.save_item(key, value)
	M._storage[key] = value
	M.save()
end

return M
