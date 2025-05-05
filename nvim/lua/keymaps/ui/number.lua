local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'
local signal = require 'util.signal'

local relativenumber = signal.new(true)

signal.persist(relativenumber, 'vim.relativenumber')

local function update_relativenumber(win)
	local opts = { win = win, scope = 'local' }
	local has_numbers = vim.api.nvim_get_option_value('number', opts)
	if has_numbers then
		vim.api.nvim_set_option_value('relativenumber', relativenumber(), opts)
	end
end

signal.watch(function()
	relativenumber()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		update_relativenumber(win)
	end
end)

local augroup = autocmd.group 'number'

augroup:on({ 'WinEnter', 'VimEnter' }, '*', function(event)
	local win = vim.api.nvim_get_current_win()
	local buftype = vim.api.nvim_get_option_value('buftype', { buf = event.buf })

	if buftype == '' then
		vim.api.nvim_set_option_value('number', true, { win = win, scope = 'local' })
	end

	update_relativenumber(win)
end)

local function toggle_relativenumber()
	relativenumber(not relativenumber())
end

keymap {
	[{ 'n', desc = 'UI: %s' }] = {
		['<leader>un'] = { toggle_relativenumber, 'Toggle relativenumber' },
	},
}
