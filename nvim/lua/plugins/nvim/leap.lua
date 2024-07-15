return {
	'ggandor/leap.nvim',

	lazy = false,

	config = function()
		local util = require 'util'
		local leap = require 'leap'

		leap.setup {}

		leap.opts.case_sensitive = false
		leap.opts.highlight_unlabeled_phase_one_targets = true

		util.declare_keymaps {
			[{ 'n', 'x', 'o' }] = {
				['s'] = '<Plug>(leap-forward)',
				['S'] = '<Plug>(leap-backward)',
				['gs'] = '<Plug>(leap-from-window)',
			},

			v = {
				['x'] = '<Plug>(leap-forward)',
				['X'] = '<Plug>(leap-backward)',
			},
		}

		local function setup_highlights()
			vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = util.get_hl_attr('@comment', 'fg') })
			vim.api.nvim_set_hl(0, 'LeapMatch', { fg = util.get_hl_attr('Search', 'fg'), reverse = true })
			vim.api.nvim_set_hl(0, 'LeapLabel', { fg = util.get_hl_attr('@diff.change', 'fg'), reverse = true })
		end

		setup_highlights()

		vim.api.nvim_create_autocmd('ColorScheme', {
			callback = setup_highlights,
		})
	end,
}
