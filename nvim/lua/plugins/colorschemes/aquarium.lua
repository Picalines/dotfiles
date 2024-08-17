return {
	'frenzyexists/aquarium-vim',

	lazy = false,

	priority = 1000,

	config = function()
		vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
			pattern = '*',
			command = [[
				if g:colors_name ==# "aquarium"
					highlight NonText guibg=none
				endif
			]],
		})
	end,
}
