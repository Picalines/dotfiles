return {
	'michaelrommel/nvim-silicon',

	enabled = false,

	event = 'VeryLazy',

	opts = {
		font = 'Hack Nerd Font Mono',
		theme = 'Visual Studio Dark+',

		background = '#fff0',
		background_image = nil,

		pad_horiz = 25,
		pad_vert = 20,

		no_round_corner = false,
		no_window_controls = true,
		no_line_number = false,
		line_offset = function(args)
			return args.line1
		end,

		line_pad = 2,
		tab_width = 4,
		language = function()
			return vim.bo.filetype
		end,

		shadow_blur_radius = 0,
		shadow_offset_x = 0,
		shadow_offset_y = 0,
		shadow_color = '#100808',

		gobble = true,
		to_clipboard = true,
		command = 'silicon',
	},

	config = function(_, opts)
		local keymap = require 'util.keymap'

		require('silicon').setup(opts)

		keymap.declare {
			[{ silent = true }] = {
				[{ 'v' }] = {
					['<leader><leader>s'] = { ':Silicon<CR>', 'Screenshot selected lines' },
				},

				[{ 'n' }] = {
					['<leader><leader>s'] = { 'maggVG:Silicon<CR><esc>`a', 'Screenshot buffer' },
				},
			},
		}
	end,
}
