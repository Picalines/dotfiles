return {
	'https://codeberg.org/andyg/leap.nvim',

	event = 'VeryLazy',

	config = function()
		local leap = require 'leap'

		leap.opts.case_sensitive = false

		leap.opts.special_keys.next_target = { '<Enter>' }
		leap.opts.special_keys.prev_target = { '<S-Enter>' }
		leap.opts.special_keys.next_group = { '<Tab>' }
		leap.opts.special_keys.prev_group = { '<S-Tab>' }

		leap.opts.labels = 'sjklhodweimbuyvrgtaqpcxzSFJKLHODWEIMBUYVRGTAQPCXZ'
		leap.opts.safe_labels = 'fFtThHlLMuUG' -- "I never press X right after jump"

		leap.opts.vim_opts['go.hlsearch'] = false
		leap.opts.vim_opts['wo.spell'] = false
		leap.opts.vim_opts['wo.conceallevel'] = nil -- for mini.files
	end,

	init = function()
		local keymap = require 'mappet'
		local map, sub = keymap.map, keymap.sub

		local keys = keymap.group 'plugins.edit.leap'

		keys('Leap: %s', { 'n' }) {
			sub { 'x', 'o' } {
				map('f', 'to') '<Plug>(leap-forward)',
				map('F', 'backward to') '<Plug>(leap-backward)',
				map('t', 'till') '<Plug>(leap-forward-till)',
				map('T', 'backward till') '<Plug>(leap-backward-till)',
			},

			map('R', 'remote') {
				function()
					require('leap.remote').action()
				end,
			},
		}

		keys('Leap: %s', { 'x', 'o' }) {
			map('an', 'treesitter node') {
				function()
					require('leap.treesitter').select {
						opts = require('leap.user').with_traversal_keys('n', 'N'),
					}
				end,
			},
		}
	end,
}
