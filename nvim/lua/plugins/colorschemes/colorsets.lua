return {
	'Picalines/colorsets.nvim',

	lazy = false,
	priority = 1000,

	init = function()
		local keymap = require 'mappet'
		local map = keymap.map

		local keys = keymap.group 'colorsets'

		keys 'UI: %s' {
			map('<Leader>ob', 'toggle light/dark') '<Cmd>Colorset daytime next<CR>',
		}
	end,

	---@module 'colorsets'
	---@type ColorsetsConfigPartial
	opts = {
		sets = {
			daytime = {
				modes = { 'light', 'dark' },
				colorschemes = {
					{ light = 'dayfox', dark = 'nightfox' },
					{ light = 'dawnfox', dark = 'duskfox' },
					{ light = 'perpetua-light', dark = 'perpetua-dark' },
					{ light = 'miniwinter-light', dark = 'miniwinter-dark' },
					{ light = 'minispring-light', dark = 'minispring-dark' },
					{ light = 'minisummer-light', dark = 'minisummer-dark' },
					{ light = 'miniautumn-light', dark = 'miniautumn-dark' },
				},
			},
		},
	},
}
