return {
	'ggandor/leap.nvim',

	lazy = false,

	config = function()
		local keymap = require 'util.keymap'
		local hl = require 'util.highlight'
		local leap = require 'leap'

		leap.setup {}

		leap.opts.case_sensitive = false
		leap.opts.highlight_unlabeled_phase_one_targets = true

		leap.opts.special_keys.next_target = '<Enter>'
		leap.opts.special_keys.prev_target = '<S-Enter>'
		leap.opts.special_keys.next_group = '<Tab>'
		leap.opts.special_keys.prev_group = '<S-Tab>'

		keymap.declare {
			[{ 'n', 'x', 'o' }] = {
				['s'] = { '<Plug>(leap-forward)', 'Leap forward' },
				['S'] = { '<Plug>(leap-backward)', 'Leap backward' },
				['gs'] = { '<Plug>(leap-from-window)', 'Leap global' },
			},

			[{ 'v' }] = {
				['x'] = '<Plug>(leap-forward)',
				['X'] = '<Plug>(leap-backward)',
			},
		}

		local function setup_highlights()
			vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = hl.hl_attr('@comment', 'fg') })
			vim.api.nvim_set_hl(0, 'LeapMatch', { fg = hl.hl_attr('Search', 'fg'), reverse = true })
			vim.api.nvim_set_hl(0, 'LeapLabel', { fg = hl.hl_attr('@diff.change', 'fg'), reverse = true })
		end

		setup_highlights()

		vim.api.nvim_create_autocmd('ColorScheme', {
			callback = setup_highlights,
		})
	end,
}
