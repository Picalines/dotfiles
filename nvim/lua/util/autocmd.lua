local array = require 'util.array'
local func = require 'util.func'

local M = {}

local SAFE_GROUP_FORMAT = 'config(%s)'

M.UNSUB = {} -- return this in a callback to delete autocmd

---@param callback_or_cmd fun(event: autocmd_event) | string
---@return fun(event: autocmd_event) | nil, string | nil
local function parse_callback_or_cmd(callback_or_cmd)
	local callback, cmd

	if type(callback_or_cmd) == 'function' then
		callback = function(...)
			return callback_or_cmd(...) == M.UNSUB
		end

		cmd = nil
	else
		callback = nil
		cmd = callback_or_cmd
	end

	return callback, cmd
end

---@class Group
---@field private _group_id number
local Group = {}

---@class autocmd_event
---@field buf integer
---@field match string
---@field data any

---@param event string | string[]
---@param pattern string | string[]
---@param callback_or_cmd fun(event: autocmd_event) | string
function Group:on(event, pattern, callback_or_cmd)
	local callback, cmd = parse_callback_or_cmd(callback_or_cmd)

	vim.api.nvim_create_autocmd(event, {
		group = self._group_id,
		pattern = pattern,
		callback = callback,
		command = cmd,
	})
end

function Group:on_user(event, callback_or_cmd)
	local callback, cmd = parse_callback_or_cmd(callback_or_cmd)

	vim.api.nvim_create_autocmd('User', {
		group = self._group_id,
		pattern = event,
		callback = callback,
		command = cmd,
	})
end

---@param filetypes string | string[]
---@param callback_or_cmd fun(event: autocmd_event) | string
function Group:on_filetype(filetypes, callback_or_cmd)
	local callback, cmd = parse_callback_or_cmd(callback_or_cmd)

	if type(filetypes) ~= 'table' then
		filetypes = { filetypes }
	end

	filetypes = array.copy(filetypes)

	return self:on('FileType', '*', function(event)
		if not array.contains(filetypes, event.match) then
			return
		end

		if callback then
			return callback(event)
		else
			vim.cmd(cmd)
		end
	end)
end

---@class group_opts
---@field clear? boolean

---@param name string
---@param opts? group_opts
---@return Group
function M.group(name, opts)
	opts = func.default_opts(opts, {
		clear = true,
	})

	name = string.format(SAFE_GROUP_FORMAT, name)

	return setmetatable({
		_group_id = vim.api.nvim_create_augroup(name, {
			clear = opts.clear,
		}),
	}, {
		__index = Group,
	})
end

return M
