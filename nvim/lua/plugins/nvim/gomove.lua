return {
	'booperlv/nvim-gomove',

	event = 'VeryLazy',

	opts = {
		-- <A-hjkl> move
		-- <A-HJKL> duplicate
		map_defaults = true,

		reindent = true,
		undojoin = true,
		move_past_end_col = false,
	},
}
