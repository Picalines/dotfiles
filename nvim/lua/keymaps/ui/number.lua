local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'
local options = require 'util.options'
local signal = require 'util.signal'

local relativenumber = signal.new(true)

signal.persist(relativenumber, 'vim.relativenumber')

local function update_relativenumber(win)
	local wo = options.winlocal(win)
	if wo.number then
		wo.relativenumber = relativenumber()
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
	local bo, wo, win = options.buflocal(event.buf)
	if bo.buftype == '' then
		wo.number = true
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
