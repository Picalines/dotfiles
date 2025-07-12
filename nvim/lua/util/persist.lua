local func = require 'util.func'
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

	local stored_json = file:read '*a'
	file:close()

	M._storage = vim.json.decode(stored_json)
end

M.save = func.debounce(500, function()
	local json_to_store = vim.json.encode(M._storage)

	if json_to_store == '[]' then
		json_to_store = '{}'
	end

	local file = io.open(PERSIST_PATH, 'w+')
	if not file then
		vim.notify(PERSIST_PATH .. ': failed to write', vim.log.levels.ERROR)
	else
		file:write(json_to_store)
		file:close()
	end
end)

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

---@generic T
---@param key string
---@param value T
---@return T
function M.save_item(key, value)
	if M._storage[key] ~= value then
		M._storage[key] = value
		M.save()
	end

	return value
end

function M.clear()
	M._storage = {}
	M.save()
end

vim.api.nvim_create_user_command('Persist', function(opts)
	local action = opts.fargs[1]

	if action == 'clear' then
		M.clear()
		vim.notify 'persist file cleared'
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
