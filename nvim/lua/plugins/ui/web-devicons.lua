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

		override_by_extension = {
			['html'] = {
				icon = '',
				color = '#ea5f25',
				cterm_color = '166',
				name = 'Html',
			},
			['css'] = {
				icon = '',
				color = '#623194',
				cterm_color = '55',
				name = 'Css',
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
			['pnpm-lock.yaml'] = {
				icon = '',
				color = '#f2a702',
				cterm_color = '11',
				name = 'Pnpm',
			},
			['pnpm-workspace.yaml'] = {
				icon = '',
				color = '#f2a702',
				cterm_color = '11',
				name = 'Pnpm',
			},
			['turbo.json'] = {
				icon = '󰧂',
				color = '#ba49ac',
				cterm_color = '97',
				name = 'Turborepo',
			},
			['biome.json'] = {
				icon = '',
				color = '#60a5fa',
				cterm_color = '111',
				name = 'Biome',
			},
			['playwright.config.ts'] = {
				icon = '',
				color = '#45ba4b',
				cterm_color = '71',
				name = 'Playwright',
			},
			['vite.config.js'] = {
				icon = '',
				color = '#ffcd25',
				cterm_color = '71',
				name = 'Vite',
			},
			['vitest.config.js'] = {
				icon = '',
				color = '#739b19',
				cterm_color = '71',
				name = 'Vitest',
			},
		},
	},
}
