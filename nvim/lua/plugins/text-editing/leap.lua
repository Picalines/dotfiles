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

		local function exclude(iarray, excluded_items)
			return array.filter(iarray, function(item)
				return not array.contains(excluded_items, item)
			end)
		end

		local unsafe_labels = { ',', '.', '/', ':', '?', 'N', 'n' }

		leap.opts.labels = exclude(leap.opts.labels, unsafe_labels)
		leap.opts.safe_labels = exclude(leap.opts.safe_labels, unsafe_labels)

		local function select_node_clever(forward_key)
			local special_keys = tbl.copy_deep(leap.opts.special_keys)
			special_keys.next_target = array.concat({ forward_key }, special_keys.next_target)
			special_keys.prev_target = array.concat({ string.upper(forward_key) }, special_keys.prev_target)

			leap_treesitter.select {
				opts = {
					special_keys = special_keys,
					labels = leap.opts.safe_labels,
				},
			}
		end

		keymap {
			[{ 'n', 'x', 'o' }] = {
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
			hl.link('LeapLabel', 'Search')
			leap.init_hl()
		end

		setup_highlights()

		local augroup = autocmd.group 'leap'

		augroup:on('ColorScheme', '*', setup_highlights)
	end,
}
