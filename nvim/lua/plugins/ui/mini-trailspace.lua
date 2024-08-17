return {
	'echasnovski/mini.trailspace',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		only_in_normal_buffers = true,
	},

	config = function(_, opts)
		local hl = require 'util.highlight'

		require('mini.trailspace').setup(opts)

		hl.link('MiniTrailspace', 'Visual')
	end,
}
