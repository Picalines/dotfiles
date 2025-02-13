return {
	'echasnovski/mini.surround',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		n_lines = 20,

		respect_selection_type = true,

		search_method = 'cover_or_next',

		silent = true,

		highlight_duration = 500,

		mappings = {
			add = 'gs',
			delete = 'dgs',
			replace = 'cgs',

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
