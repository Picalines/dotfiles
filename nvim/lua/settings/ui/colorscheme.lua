local autocmd = require 'util.autocmd'
local persist = require 'util.persist'

autocmd.on_colorscheme('*', function()
	persist.save_item('colorscheme', vim.g.colors_name)
	persist.save_item('background', vim.o.background)
end)

local function load_colorscheme()
	vim.cmd.highlight 'clear'
	vim.cmd.syntax 'reset'

	vim.cmd.colorscheme(persist.get_item('colorscheme', 'default'))
	vim.o.background = persist.get_item('background', 'dark')
end

-- NOTE: all colorschemes should be loaded already.
local ok, error = pcall(load_colorscheme)
if not ok then
	print('failed to load persisted colorscheme: ' .. vim.inspect(error))
end
