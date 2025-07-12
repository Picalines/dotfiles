return {
	'ggandor/leap.nvim',

	lazy = false,

	config = function()
		local autocmd = require 'util.autocmd'
		local func = require 'util.func'
		local hl = require 'util.highlight'
		local keymap = require 'util.keymap'

		local leap = require 'leap'

		leap.setup {}

		leap.opts.case_sensitive = false
		leap.opts.highlight_unlabeled_phase_one_targets = true

		leap.opts.special_keys.next_target = { '<Enter>' }
		leap.opts.special_keys.prev_target = { '<S-Enter>' }
		leap.opts.special_keys.next_group = { '<Tab>' }
		leap.opts.special_keys.prev_group = { '<S-Tab>' }

		local function select_node()
			require('leap.treesitter').select { opts = require('leap.user').with_traversal_keys('n', 'N') }
		end

		keymap {
			[{ 'n', 'x', 'o' }] = {
				['s'] = { '<Plug>(leap-forward)', 'Leap forward' },
				['S'] = { '<Plug>(leap-backward)', 'Leap backward' },
			},

			[{ 'x', 'o' }] = {
				['an'] = { func.curry(select_node, 'n'), 'Leap treesitter node' },
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
