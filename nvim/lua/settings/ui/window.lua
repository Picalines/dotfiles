local array = require 'util.array'
local autocmd = require 'util.autocmd'

local augroup = autocmd.group 'window'

vim.go.mouse = 'a'
vim.go.termguicolors = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.go.scrolloff = 8

vim.o.laststatus = 3 -- global statusline

augroup:on({ 'TabNew', 'WinNew', 'WinEnter', 'BufWinEnter', 'TermOpen' }, '*', function()
	local tab_winids = vim.api.nvim_tabpage_list_wins(0)

	local has_normal_bufs = array.some(tab_winids, function(winid)
		local buf = vim.api.nvim_win_get_buf(winid)
		local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
		local config = vim.api.nvim_win_get_config(winid)
		return buftype == '' and config.relative == ''
	end)

	vim.o.showtabline = has_normal_bufs and 2 or 1 -- always OR only when #tabpages > 1
end)
