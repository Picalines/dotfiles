return {
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					'tw`([^`]*)',
					'clsx[`]([\\s\\S][^`]*)[`]',
					{ 'clsx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
				},
			},
		},
	},
}
