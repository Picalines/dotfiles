return {
	'echasnovski/mini.trailspace',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		only_in_normal_buffers = true,
	},

	config = function(_, opts)
		require('mini.trailspace').setup(opts)

		vim.api.nvim_set_hl(0, 'MiniTrailspace', { link = 'Visual' })
	end,
}
