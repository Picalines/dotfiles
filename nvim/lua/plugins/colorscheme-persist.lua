return {
	'propet/colorscheme-persist.nvim',
	lazy = false,
	priority = 900,
	config = function()
		local colorscheme_persist = require("colorscheme-persist")

		colorscheme_persist.setup()

		local colorscheme = colorscheme_persist.get_colorscheme()
		vim.cmd("colorscheme " .. colorscheme)

		vim.keymap.set("n", "<leader>ft", colorscheme_persist.picker,
			{ noremap = true, silent = true, desc = "Select color [T]heme" })
	end,
}
