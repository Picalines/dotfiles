local array = require 'util.array'

local M = {}

---@class autocmd_event
---@field buf integer
---@field data any

local on_group = vim.api.nvim_create_augroup('autocmd.on', { clear = true })

---@param event string | string[]
---@param pattern string | string[]
---@param callback fun(event: autocmd_event)
function M.on(event, pattern, callback)
	vim.api.nvim_create_autocmd(event, {
		group = on_group,
		pattern = pattern,
		callback = vim.schedule_wrap(callback),
	})
end

local on_user_group = vim.api.nvim_create_augroup('autocmd.on_user', { clear = true })

---@param event string | string[]
---@param callback fun(event: autocmd_event)
function M.on_user(event, callback)
	vim.api.nvim_create_autocmd('User', {
		group = on_user_group,
		pattern = event,
		callback = vim.schedule_wrap(callback),
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
		local filetype = vim.api.nvim_get_option_value('filetype', { buf = event.buf })
		if array.contains(filetypes, filetype) then
			callback(event)
		end
	end)
end

---@param colorscheme string | string[]
---@param callback fun(event: autocmd_event)
function M.on_colorscheme(colorscheme, callback)
	vim.api.nvim_create_autocmd('ColorScheme', {
		pattern = colorscheme,
		callback = callback,
	})

	return M.on('ColorScheme', colorscheme, callback)
end

return M
