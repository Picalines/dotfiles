return {
	'HiPhish/rainbow-delimiters.nvim',

	event = 'VeryLazy',

	main = 'rainbow-delimiters.setup',

	opts = {
		highlight = {
			'RainbowDelimiterYellow',
			'RainbowDelimiterBlue',
			'RainbowDelimiterGreen',
			'RainbowDelimiterViolet',
			'RainbowDelimiterCyan',
		},
	},
}
