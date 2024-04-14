return {
	'propet/colorscheme-persist.nvim',

	lazy = false,

	priority = 900,

	config = function()
		local colorscheme_persist = require 'colorscheme-persist'
		local util = require 'util'

		colorscheme_persist.setup()

		local function load_colorscheme()
			local colorscheme = colorscheme_persist.get_colorscheme()
			vim.cmd('colorscheme ' .. colorscheme)
		end

		pcall(load_colorscheme)

		vim.api.nvim_create_user_command('PickColorScheme', colorscheme_persist.picker, { nargs = 0 })

		util.declare_keymaps {
			opts = {
				silent = true,
			},
			n = {
				['<leader><C-T>'] = { ':PickColorScheme<CR>', desc = 'Select color [T]heme' },
			},
		}
	end,
}
