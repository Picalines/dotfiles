-- NOTE: all colorschemes should be loaded already.

local autocmd = require 'util.autocmd'
local hl = require 'util.highlight'
local signal = require 'util.signal'

local function patch_colorscheme()
	local attrs = { 'bg', 'reverse' }
	hl.clear('TabLine', attrs)
	hl.clear('StatusLine', attrs)
	hl.clear('WinSeparator', attrs)
	hl.clear('NormalFloat', attrs)
	hl.clear('NonText', attrs)
	hl.clear('EndOfBuffer', attrs)
	hl.clear('DiffAdd', attrs)
	hl.clear('DiffText', attrs)
	hl.clear('DiffChange', attrs)
	hl.clear('DiffDelete', attrs)
end

vim.api.nvim_create_user_command('PatchColorScheme', patch_colorscheme, {})

local colorscheme = signal.new 'default'
local background = signal.new 'dark'

signal.persist(colorscheme, 'vim.colorscheme')
signal.persist(background, 'vim.background')

signal.watch(function()
	local ok, error = pcall(vim.cmd.colorscheme, colorscheme())
	if not ok then
		print('failed to load persisted colorscheme: ' .. vim.inspect(error))
	end

	vim.g.background = background()
end)

local function on_colorscheme()
	colorscheme(vim.g.colors_name)
	background(vim.o.background)
end

local augroup = autocmd.group 'colorscheme'

augroup:on('ColorScheme', '*', on_colorscheme)

on_colorscheme()
