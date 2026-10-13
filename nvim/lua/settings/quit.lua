local app = require 'util.app'
local autocmd = require 'util.autocmd'
local func = require 'util.func'
local keymap = require 'mappet'

local augroup = autocmd.group 'settings.quit'
local ns = vim.api.nvim_create_namespace 'settings.quit'

local map = keymap.map
local keys = keymap.group 'settings.quit'

keys { 'n' } {
	map('<Leader><Leader>q', 'write all and quit') '<Cmd>wqa<CR>',
}

local function running_terminals()
	return vim.iter(vim.api.nvim_list_chans()):filter(function(chan)
		return chan.mode == 'terminal' and chan.stream == 'job'
	end)
end

-- stop terminals before exiting editor
augroup:on('ExitPre', '*', function()
	for chan in running_terminals() do
		vim.fn.jobstop(chan.id)
	end
end)

-- auto exit if inactive long
local function quit_if_saved()
	local any_modified = vim.iter(vim.api.nvim_list_bufs()):any(function(buffer)
		return vim.bo[buffer].modified
	end)

	local terminals_running = running_terminals():peek() ~= nil

	if not (any_modified or terminals_running) then
		vim.cmd 'qall'
	end
end

if app.client() == 'terminal' then
	local ms_hour = 60 * 60 * 1000
	local reset_quit_timer = func.debounce(ms_hour * 2, quit_if_saved)

	vim.on_key(reset_quit_timer, ns)
	reset_quit_timer()
end
