return {
	'ggandor/leap.nvim',

	event = 'VeryLazy',

	config = function()
		local leap = require 'leap'

		leap.opts.case_sensitive = false
		leap.opts.highlight_unlabeled_phase_one_targets = true

		leap.opts.special_keys.next_target = { '<Enter>' }
		leap.opts.special_keys.prev_target = { '<S-Enter>' }
		leap.opts.special_keys.next_group = { '<Tab>' }
		leap.opts.special_keys.prev_group = { '<S-Tab>' }

		leap.opts.labels = 'sjklhodweimbuyvrgtaqpcxzSFJKLHODWEIMBUYVRGTAQPCXZ'
		leap.opts.safe_labels = 'fFtThHlLMuUG' -- "I never press X right after jump"

		leap.opts.vim_opts['go.hlsearch'] = false
		leap.opts.vim_opts['wo.spell'] = false
	end,

	init = function()
		local keymap = require 'util.keymap'

		local function select_node()
			require('leap.treesitter').select {
				opts = require('leap.user').with_traversal_keys('n', 'N'),
			}
		end

		keymap {
			[{ 'n', 'x', 'o', desc = 'leap %s' }] = {
				['f'] = { '<Plug>(leap-forward-to)', 'to' },
				['F'] = { '<Plug>(leap-backward-to)', 'backward to' },

				['t'] = { '<Plug>(leap-forward-till)', 'till' },
				['T'] = { '<Plug>(leap-backward-till)', 'backward till' },
			},

			[{ 'x', 'o' }] = {
				['an'] = { select_node, 'Leap treesitter node' },
			},
		}
	end,
}
