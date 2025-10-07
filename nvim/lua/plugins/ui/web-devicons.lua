return {
	'nvim-tree/nvim-web-devicons',

	lazy = true,
	event = 'VeryLazy',

	opts = {
		override_by_extension = {
			['module.ts'] = {
				icon = '',
				color = '#da214c',
				cterm_color = '161',
				name = 'NestModule',
			},
			['service.ts'] = {
				icon = '',
				color = '#519aba',
				cterm_color = '74',
				name = 'NestService',
			},
			['controller.ts'] = {
				icon = '',
				color = '#90d402',
				cterm_color = '76',
				name = 'NestController',
			},
			['resolver.ts'] = {
				icon = '',
				color = '#90d402',
				cterm_color = '76',
				name = 'NestResolver',
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
			['biome.jsonc'] = {
				icon = '',
				color = '#60a5fa',
				cterm_color = '111',
				name = 'Biome',
			},
		},
	},
}
