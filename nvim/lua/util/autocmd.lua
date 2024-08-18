local array = require 'util.array'

local M = {}

local per_ft_group = vim.api.nvim_create_augroup('per_filetype', { clear = true })

---@param filetypes string | string[]
---@param callback fun(event: any)
function M.per_filetype(filetypes, callback)
	if type(filetypes) ~= 'table' then
		filetypes = { filetypes }
	end

	filetypes = array.copy(filetypes)

	vim.api.nvim_create_autocmd('FileType', {
		group = per_ft_group,
		callback = function(event)
			local filetype = vim.api.nvim_get_option_value('filetype', { buf = event.buf })
			if array.contains(filetypes, filetype) then
				callback(event)
			end
		end,
	})
end

local on_colorscheme_group = vim.api.nvim_create_augroup('on_colorscheme', { clear = true })

---@param colorscheme string | string[]
---@param callback fun(event: any)
function M.on_colorscheme(colorscheme, callback)
	vim.api.nvim_create_autocmd('ColorScheme', {
		group = on_colorscheme_group,
		pattern = colorscheme,
		callback = callback,
	})
end

local on_terminal_open_group = vim.api.nvim_create_augroup('on_terminal_open', { clear = true })

---@param callback fun(event: any)
function M.on_terminal_open(callback)
	vim.api.nvim_create_autocmd('TermOpen', {
		group = on_terminal_open_group,
		callback = callback,
	})
end

local on_user_event = vim.api.nvim_create_augroup('on_user_event', { clear = true })

---@param event string | string[]
---@param callback fun(event: any)
function M.on_user_event(event, callback)
	vim.api.nvim_create_autocmd('User', {
		group = on_user_event,
		pattern = event,
		callback = callback,
	})
end

return M
