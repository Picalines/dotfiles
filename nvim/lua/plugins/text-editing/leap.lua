return {
	'ggandor/leap.nvim',

	lazy = false,

	config = function()
		local array = require 'util.array'
		local autocmd = require 'util.autocmd'
		local func = require 'util.func'
		local hl = require 'util.highlight'
		local keymap = require 'util.keymap'
		local tbl = require 'util.table'

		local leap = require 'leap'
		local leap_treesitter = require 'leap.treesitter'

		leap.setup {}

		leap.opts.case_sensitive = false
		leap.opts.highlight_unlabeled_phase_one_targets = true

		leap.opts.special_keys.next_target = { '<Enter>' }
		leap.opts.special_keys.prev_target = { '<S-Enter>' }
		leap.opts.special_keys.next_group = { '<Tab>' }
		leap.opts.special_keys.prev_group = { '<S-Tab>' }

		local unsafe_labels = { 'n' }

		leap.opts.safe_labels = array.filter(leap.opts.safe_labels, function(label)
			return not array.contains(unsafe_labels, label)
		end)

		local function select_node_clever(forward_key)
			local special_keys = tbl.copy_deep(leap.opts.special_keys)
			special_keys.next_target = array.concat({ forward_key }, special_keys.next_target)
			special_keys.prev_target = array.concat({ string.upper(forward_key) }, special_keys.prev_target)

			leap_treesitter.select {
				opts = { special_keys = special_keys },
			}
		end

		keymap.declare {
			[{ 'n', 'v', 'x', 'o' }] = {
				['s'] = { '<Plug>(leap-forward)', 'Leap forward' },
				['S'] = { '<Plug>(leap-backward)', 'Leap backward' },
			},

			[{ 'x', 'o' }] = {
				['an'] = { func.curry(select_node_clever, 'n'), 'Leap treesitter node' },
			},
		}

		local function setup_highlights()
			hl.clear('LeapBackdrop', 'all')
			hl.link('LeapMatch', 'CurSearch')
			hl.link('LeapLabel', 'CurSearch')
		end

		setup_highlights()

		autocmd.on_colorscheme('*', setup_highlights)
	end,
}
