return {
	'perpetuatheme/nvim',
	name = 'perpetua',
	lazy = false,
	priority = 1000,

	init = function()
		local autocmd = require 'util.autocmd'
		local hl = require 'util.highlight'

		hl.link_colorschemes_by_background(autocmd.group 'perpetua', {
			light = 'perpetua-light',
			dark = 'perpetua-dark',
		})
	end,
}
