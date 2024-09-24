return {
	'echasnovski/mini.surround',

	event = 'VeryLazy',

	opts = {
		n_lines = 20,

		respect_selection_type = true,

		search_method = 'cover_or_next',

		silent = false,

		highlight_duration = 500,

		mappings = {
			add = 'yp',
			delete = 'dp',
			replace = 'cp',

			find = '',
			find_left = '',
			highlight = '',
			suffix_last = '',
			suffix_next = '',
			update_n_lines = '',
		},

		custom_surroundings = nil,
	},
}
