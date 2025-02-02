return {
	settings = {
		tailwindCSS = {
			experimental = {
				configFile = {
					['src/styles/index.css'] = '**',
					['src/app/index.css'] = '**',
				},

				classRegex = {
					'tw`([^`]*)',
					'clsx[`]([\\s\\S][^`]*)[`]',
					{ 'clsx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					{ 'cva\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					{ 'cn\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					{ 'withClassName\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
				},
			},
		},
	},
}
