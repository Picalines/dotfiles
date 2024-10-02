local array = require 'util.array'

local M = {}

---@class autocmd_event
---@field buf integer
---@field match string
---@field data any

local on_group = vim.api.nvim_create_augroup('autocmd.on', { clear = true })

---@param callback_or_cmd fun(event: autocmd_event) | string
---@return fun(event: autocmd_event) | nil, string | nil
local function parse_callback_or_cmd(callback_or_cmd)
	local callback, cmd

	if type(callback_or_cmd) == 'function' then
		callback = callback_or_cmd
		cmd = nil
	else
		callback = nil
		cmd = callback_or_cmd
	end

	return callback, cmd
end

---@param event string | string[]
---@param pattern string | string[]
---@param callback_or_cmd fun(event: autocmd_event) | string
function M.on(event, pattern, callback_or_cmd)
	local callback, cmd = parse_callback_or_cmd(callback_or_cmd)

	vim.api.nvim_create_autocmd(event, {
		group = on_group,
		pattern = pattern,
		callback = callback,
		command = cmd,
	})
end

local on_user_group = vim.api.nvim_create_augroup('autocmd.on_user', { clear = true })

---@param event string | string[]
---@param callback_or_cmd fun(event: autocmd_event) | string
function M.on_user(event, callback_or_cmd)
	local callback, cmd = parse_callback_or_cmd(callback_or_cmd)

	vim.api.nvim_create_autocmd('User', {
		group = on_user_group,
		pattern = event,
		callback = callback,
		command = cmd,
	})
end

---@param filetypes string | string[]
---@param callback fun(event: autocmd_event)
function M.on_filetype(filetypes, callback)
	if type(filetypes) ~= 'table' then
		filetypes = { filetypes }
	end

	filetypes = array.copy(filetypes)

	return M.on('FileType', '*', function(event)
		if array.contains(filetypes, event.match) then
			callback(event)
		end
	end)
end

---@param colorscheme string | string[]
---@param callback fun(event: autocmd_event)
function M.on_colorscheme(colorscheme, callback)
	return M.on('ColorScheme', colorscheme, callback)
end

return M
