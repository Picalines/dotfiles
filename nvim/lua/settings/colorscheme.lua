-- NOTE: all colorschemes should be loaded already.

local autocmd = require 'util.autocmd'
local hl = require 'util.highlight'
local keymap = require 'util.keymap'
local signal = require 'util.signal'

keymap {
	[{ 'n', desc = 'UI: %s' }] = {
		['<Leader>l'] = {
			desc = 'toggle background',
			function()
				vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
			end,
		},
	},
}

local function colorscheme_init()
	for _, hl_group in ipairs {
		'EndOfBuffer',
		'NonText',
		'NormalFloat',
		'SignColumn',
		'StatusLine',
		'StatusLineNC',
		'StatusLineTerm',
		'StatusLineTermNC',
		'TabLine',
		'TabLineFill',
		'WinBar',
		'WinBarNC',
		'WinSeparator',
	} do
		hl.clear(hl_group, { 'bg', 'reverse' })
	end
end

local augroup = autocmd.group 'settings.ui.colorscheme'

augroup:on_user('ColorSchemeInit', colorscheme_init)

-- NOTE: `background` should be handled by a terminal / GUI
local startup_colorscheme = signal.new 'default'

signal.persist(startup_colorscheme, 'vim.colorscheme')

pcall(vim.cmd.colorscheme, startup_colorscheme())

augroup:on('ColorScheme', '*', function()
	if vim.g.colors_name then
		startup_colorscheme(vim.g.colors_name)
	end
end)
