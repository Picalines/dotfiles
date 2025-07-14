local M = {}

local SAFE_GROUP_FORMAT = 'config(%s)'

M.UNSUB = {} -- return this in a callback to delete autocmd

---@class autocmd_event
---@field buf integer
---@field match string
---@field data any

---@class autocmd_opts
---@field once boolean?

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

---@class AutocmdGroup
---@field private _group_id number
local Group = {}

---@param event string | string[]
---@param pattern string | string[]
---@param callback_or_cmd autocmd_callback | string
---@param opts autocmd_opts?
function Group:on(event, pattern, callback_or_cmd, opts)
	opts = vim.tbl_deep_extend('keep', opts or {}, { once = false })

	local callback, cmd = parse_callback_or_cmd(callback_or_cmd)

	vim.api.nvim_create_autocmd(event, {
		group = self._group_id,
		pattern = pattern,
		callback = callback,
		command = cmd,
		once = opts.once,
	})
end

---@param event string | string[]
---@param callback_or_cmd autocmd_callback | string
---@param opts autocmd_opts?
function Group:on_user(event, callback_or_cmd, opts)
	return self:on('User', event, callback_or_cmd, opts)
end

---@class group_opts
---@field clear? boolean

---@param name string
---@param opts? group_opts
---@return AutocmdGroup
function M.group(name, opts)
	opts = vim.tbl_deep_extend('keep', opts or {}, { clear = true })

	name = string.format(SAFE_GROUP_FORMAT, name)

	return setmetatable({
		_group_id = vim.api.nvim_create_augroup(name, {
			clear = opts.clear,
		}),
	}, {
		__index = Group,
	})
end

---@class Buffer
---@field private _buf_id? number
local Buffer = {}

---@param event string | string[]
---@param callback_or_cmd autocmd_callback | string
---@param opts autocmd_opts?
function Buffer:on(event, callback_or_cmd, opts)
	opts = vim.tbl_deep_extend('keep', opts or {}, { once = false })

	local callback, cmd = parse_callback_or_cmd(callback_or_cmd)

	vim.api.nvim_create_autocmd(event, {
		buffer = self._buf_id,
		callback = callback,
		command = cmd,
		once = opts.once,
	})
end

---@param id number
function M.buffer(id)
	return setmetatable({ _buf_id = id }, { __index = Buffer })
end

return M
