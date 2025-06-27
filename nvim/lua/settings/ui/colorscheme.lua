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

hl.fade(augroup, 'Normal', 'NormalMuted', 0.5)

-- NOTE: `background` should be handled by a terminal / GUI
local startup_colorscheme = signal.new 'default'

signal.persist(startup_colorscheme, 'vim.colorscheme')

pcall(vim.cmd.colorscheme, startup_colorscheme())

augroup:on('ColorScheme', '*', function()
	if vim.g.colors_name then
		startup_colorscheme(vim.g.colors_name)
	end
end)
