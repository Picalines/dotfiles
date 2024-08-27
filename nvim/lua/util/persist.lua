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
		return false
	end

	local jsons = vim.json.encode(M._storage)
	if jsons == '[]' then
		jsons = '{}'
	end

	file:write(jsons)
	file:close()
	return true
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

function M.clear()
	M._storage = {}
	M.save()
end

vim.api.nvim_create_user_command('Persist', function(opts)
	local action = opts.fargs[1]

	if action == 'clear' then
		M.clear()
		print 'persist file cleared'
	elseif action == 'open_file' then
		vim.cmd.e(PERSIST_PATH)
	end
end, {
	nargs = 1,
	complete = function()
		return { 'clear', 'open_file' }
	end,
})

return M
