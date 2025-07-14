return {
	'ggandor/leap.nvim',

	lazy = false,

	config = function()
		local autocmd = require 'util.autocmd'
		local hl = require 'util.highlight'
		local keymap = require 'util.keymap'

		local leap = require 'leap'

		leap.setup {}

		leap.opts.case_sensitive = false
		leap.opts.highlight_unlabeled_phase_one_targets = true

		leap.opts.special_keys.next_target = { 'n' }
		leap.opts.special_keys.prev_target = { 'N' }
		leap.opts.special_keys.next_group = { '<Tab>' }
		leap.opts.special_keys.prev_group = { '<S-Tab>' }

		leap.opts.labels = 'sjklhodweimbuyvrgtaqpcxzSFNJKLHODWEIMBUYVRGTAQPCXZ'
		leap.opts.safe_labels = 'sutSFNLHMUGTZ'

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

		local function setup_highlights()
			hl.clear('LeapBackdrop', 'all')
			hl.link('LeapMatch', 'CurSearch')
			hl.link('LeapLabel', 'Search')
			leap.init_hl()
		end

		setup_highlights()

		local augroup = autocmd.group 'leap'

		augroup:on('ColorScheme', '*', setup_highlights)
	end,
}
