return {
	'goolord/alpha-nvim',

	config = function()
		local util = require 'util'
		local alpha = require 'alpha'
		local dashboard = require 'alpha.themes.dashboard'

		dashboard.section.buttons.val = {
			dashboard.button('f', '󰈞  Find file', ':Telescope find_files<CR>'),
			dashboard.button('o', '󰮗  Old files', ':Telescope oldfiles<CR>'),
			dashboard.button('b', '󰯁  New file', ':ene <BAR> startinsert<CR>'),
			dashboard.button('e', '  File Tree', ':Neotree filesystem<CR>'),
			dashboard.button('q', '  Quit', ':qa<CR>'),
		}

		local small_height = 35
		local win_height = vim.fn.winheight(0)
		local zoom_factor = util.clamp(win_height, 0, small_height) / small_height
		local headerPadding = math.max(2, math.floor(win_height * zoom_factor * 0.2))

		dashboard.config.layout = {
			{ type = 'padding', val = headerPadding },
			dashboard.section.header,
			{ type = 'padding', val = 2 },
			dashboard.section.buttons,
			dashboard.section.footer,
		}

		alpha.setup(dashboard.opts)
	end,
}
