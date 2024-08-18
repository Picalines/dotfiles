return {
	'frenzyexists/aquarium-vim',

	lazy = false,

	priority = 1000,

	config = function()
		local autocmd = require 'util.autocmd'
		local hl = require 'util.highlight'

		autocmd.on_colorscheme('aquarium', function()
			hl.clear('NonText', 'bg')
		end)
	end,
}
