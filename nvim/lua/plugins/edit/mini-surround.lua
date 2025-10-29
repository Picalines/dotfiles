return {
	'nvim-mini/mini.surround',

	event = 'VeryLazy',

	opts = {
		n_lines = 20,

		respect_selection_type = true,

		search_method = 'cover_or_next',

		silent = true,

		highlight_duration = 500,

		mappings = {
			add = 's',
			delete = 'ds',
			replace = 'cs',
			find = '',
			find_left = '',

			highlight = '',
			suffix_last = '',
			suffix_next = '',
			update_n_lines = '',
		},

		custom_surroundings = nil,
	},

	init = function()
		local keymap = require 'util.keymap'

		keymap {
			[{ 'n', desc = 'surround %s' }] = {
				['ss'] = { 's_', 'line', remap = true },
			},
		}
	end,
}
