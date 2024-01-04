return {
	'sainnhe/sonokai',

	lazy = false,

	priority = 1000,

	config = function()
		vim.cmd [[
			let g:sonokai_transparent_background = 2
			let g:sonokai_enable_italic = 1
			let g:sonokai_diagnostic_virtual_text = 'colored'
		]]

		vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
			pattern = '*',
			command = [[
				if g:colors_name ==# "sonokai"
					highlight link NvimTreeFolderName Fg
					highlight link NvimTreeEmptyFolderName Fg
					highlight link NvimTreeOpenedFolderName Fg

					highlight NormalFloat guibg=none
					highlight FloatBorder guibg=none
				endif
			]],
		})
	end,
}
