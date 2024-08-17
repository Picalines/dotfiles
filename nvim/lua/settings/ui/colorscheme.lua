local persist = require 'util.persist'

local function load_colorscheme()
	vim.cmd 'hi clear'
	vim.cmd 'syntax reset'
	vim.cmd('colorscheme ' .. persist.get_item('colorscheme', 'default'))
end

-- NOTE: all colorschemes should be loaded already.
local ok, error = pcall(load_colorscheme)
if not ok then
	print('failed to load persisted colorscheme: ' .. vim.inspect(error))
end
