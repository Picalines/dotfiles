-- NOTE: all colorschemes should be loaded already.

local autocmd = require 'util.autocmd'
local signal = require 'util.signal'

local colorscheme = signal.new 'default'
local background = signal.new 'dark'

signal.persist(colorscheme, 'colorscheme')
signal.persist(background, 'background')

vim.cmd.highlight 'clear'
vim.cmd.syntax 'reset'

signal.watch(function()
	local ok, error = pcall(vim.cmd.colorscheme, colorscheme())
	if not ok then
		print('failed to load persisted colorscheme: ' .. vim.inspect(error))
	end

	vim.g.background = background()
end)

autocmd.on_colorscheme('*', function()
	colorscheme(vim.g.colors_name)
	background(vim.o.background)
end)
