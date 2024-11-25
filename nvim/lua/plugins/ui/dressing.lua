return {
	'stevearc/dressing.nvim',

	event = 'VeryLazy',

	opts = {
		input = {
			enabled = true,

			default_prompt = 'input:',
			title_pos = 'left',

			insert_only = true,
			start_in_insert = true,

			border = 'rounded',
			relative = 'cursor',

			prefer_width = 40,
			width = nil,
			max_width = { 140, 0.9 },
			min_width = { 20, 0.2 },

			mappings = {
				n = {
					['<Esc>'] = 'Close',
					['<CR>'] = 'Confirm',
				},
				i = {
					['<C-c>'] = 'Close',
					['<CR>'] = 'Confirm',
					['<Up>'] = 'HistoryPrev',
					['<Down>'] = 'HistoryNext',
				},
			},
		},
		select = {
			enabled = false,
		},
	},
}
