return {
	'EdenEast/nightfox.nvim',

	lazy = false,

	priority = 1000,

	opts = {
		specs = {
			all = {
				bg0 = 'bg1',
			},
		},

		groups = {
			all = {
				WinSeparator = { fg = 'palette.fg3' },
			},
		},
	},

	init = function()
		local autocmd = require 'util.autocmd'
		local hl = require 'util.highlight'

		local augroup = autocmd.group 'nightfox-theme'

		hl.link_colorschemes_by_background(augroup, {
			light = 'dayfox',
			dark = 'nightfox',
		})

		hl.link_colorschemes_by_background(augroup, {
			light = 'dawnfox',
			dark = 'duskfox',
		})
	end,
}
