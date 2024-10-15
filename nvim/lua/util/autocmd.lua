local array = require 'util.array'
local func = require 'util.func'
local tbl = require 'util.table'

local M = {}

local SAFE_GROUP_FORMAT = 'config(%s)'

M.UNSUB = {} -- return this in a callback to delete autocmd

---@class autocmd_event
---@field buf integer
---@field match string
---@field data any

---@alias autocmd_callback fun(event: autocmd_event): any

---@param callback_or_cmd autocmd_callback | string
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

---@param event string | string[]
---@param pattern string | string[]
---@param callback_or_cmd autocmd_callback | string
function Group:on(event, pattern, callback_or_cmd)
	local callback, cmd = parse_callback_or_cmd(callback_or_cmd)

	vim.api.nvim_create_autocmd(event, {
		group = self._group_id,
		pattern = pattern,
		callback = callback,
		command = cmd,
	})
end

---@param event string | string[]
---@param callback_or_cmd autocmd_callback | string
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
---@param callback_or_cmd autocmd_callback | string
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

---@class autocmd_winresized_event: autocmd_event
---@field win integer

---@param callback fun(event: autocmd_winresized_event): any
function Group:on_winresized(callback)
	return self:on('WinResized', '*', function(event)
		for _, win in ipairs(vim.v.event.windows) do
			local returned = callback(tbl.override(event, {
				win = win,
				buf = vim.api.nvim_win_get_buf(win),
			}))

			if type(returned) ~= 'nil' then
				return returned
			end
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
