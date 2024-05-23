return {
	'ggandor/leap.nvim',

	dependencies = {
		'ggandor/flit.nvim',
	},

	config = function()
		local leap = require 'leap'

		leap.opts.highlight_unlabeled_phase_one_targets = true

		leap.add_default_mappings()

		vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
	end,
}
