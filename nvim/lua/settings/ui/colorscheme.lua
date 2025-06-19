-- NOTE: all colorschemes should be loaded already.

local autocmd = require 'util.autocmd'
local hl = require 'util.highlight'
local signal = require 'util.signal'

local function colorscheme_init()
	local attrs = { 'bg', 'reverse' }
	hl.clear('EndOfBuffer', attrs)
	hl.clear('NonText', attrs)
	hl.clear('NormalFloat', attrs)
	hl.clear('SignColumn', attrs)
	hl.clear('StatusLine', attrs)
	hl.clear('StatusLineNC', attrs)
	hl.clear('StatusLineTerm', attrs)
	hl.clear('StatusLineTermNC', attrs)
	hl.clear('TabLine', attrs)
	hl.clear('TabLineFill', attrs)
	hl.clear('WinBar', attrs)
	hl.clear('WinBarNC', attrs)
	hl.clear('WinSeparator', attrs)
end

local augroup = autocmd.group 'settings.ui.colorscheme'

augroup:on_user('ColorSchemeInit', colorscheme_init)

local colorscheme = signal.new 'default'
local background = signal.new 'dark'

signal.persist(colorscheme, 'vim.colorscheme')
signal.persist(background, 'vim.background')

signal.watch(function()
	local ok, error = pcall(vim.cmd.colorscheme, colorscheme())
	if not ok then
		print('failed to load persisted colorscheme: ' .. vim.inspect(error))
	end

	vim.o.background = background()
end)

local function persist_colorscheme()
	colorscheme(vim.g.colors_name)
	background(vim.o.background)
end

augroup:on('ColorScheme', '*', persist_colorscheme)

persist_colorscheme()
