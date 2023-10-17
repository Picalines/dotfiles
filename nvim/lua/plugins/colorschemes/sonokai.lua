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
	end
}
