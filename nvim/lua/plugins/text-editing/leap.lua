return {
	'ggandor/leap.nvim',

	lazy = false,

	config = function()
		local func = require 'util.func'
		local hl = require 'util.highlight'
		local keymap = require 'util.keymap'
		local tbl = require 'util.table'
		local array = require 'util.array'

		local leap = require 'leap'
		local leap_treesitter = require 'leap.treesitter'

		leap.setup {}

		leap.opts.case_sensitive = false
		leap.opts.highlight_unlabeled_phase_one_targets = true

		leap.opts.special_keys.next_target = { '<Enter>' }
		leap.opts.special_keys.prev_target = { '<S-Enter>' }
		leap.opts.special_keys.next_group = { '<Tab>' }
		leap.opts.special_keys.prev_group = { '<S-Tab>' }

		leap.opts.safe_labels = array.filter(leap.opts.safe_labels, function(l)
			return l ~= 'n'
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
			[{ 'n', 'x', 'o' }] = {
				['s'] = { '<Plug>(leap-forward)', 'Leap forward' },
				['S'] = { '<Plug>(leap-backward)', 'Leap backward' },
				['gs'] = { '<Plug>(leap-from-window)', 'Leap global' },
			},

			[{ 'x', 'o' }] = {
				['an'] = { func.curry(select_node_clever, 'n'), 'Leap treesitter node' },
			},

			[{ 'v' }] = {
				['x'] = '<Plug>(leap-forward)',
				['X'] = '<Plug>(leap-backward)',
			},
		}

		local function setup_highlights()
			vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = hl.attr('@comment', 'fg') })
			vim.api.nvim_set_hl(0, 'LeapMatch', { fg = hl.attr('Search', 'fg'), reverse = true })
			vim.api.nvim_set_hl(0, 'LeapLabel', { fg = hl.attr('@diff.change', 'fg'), reverse = true })
		end

		setup_highlights()

		vim.api.nvim_create_autocmd('ColorScheme', {
			callback = setup_highlights,
		})
	end,
}
