return {
	'nvim-tree/nvim-web-devicons',

	priority = 1000,

	opts = {
		override = {
			['stories.tsx'] = {
				icon = '',
				color = '#eb5685',
				cterm_color = '206',
				name = 'Storybook',
			},
			['stories.jsx'] = {
				icon = '',
				color = '#eb5685',
				cterm_color = '206',
				name = 'Storybook',
			},
		},

		override_by_filename = {
			['index.ts'] = {
				icon = '',
				color = '#519aba',
				cterm_color = '68',
				name = 'TypeScriptIndex',
			},
			['index.js'] = {
				icon = '',
				color = '#cbcb41',
				cterm_color = '226',
				name = 'JavaScriptIndex',
			},
			['playwright.config.ts'] = {
				icon = '',
				color = '#45ba4b',
				cterm_color = '71',
				name = 'Playwright',
			},
		},
	},
}
