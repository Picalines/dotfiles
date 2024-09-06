return {
	'echasnovski/mini.trailspace',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		only_in_normal_buffers = true,
	},

	config = function(_, opts)
		local hl = require 'util.highlight'
		local autocmd = require 'util.autocmd'

		require('mini.trailspace').setup(opts)

		autocmd.on_colorscheme('*', function()
			hl.link('MiniTrailspace', 'Visual')
		end)
	end,
}
