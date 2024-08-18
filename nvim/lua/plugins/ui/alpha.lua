return {
	'goolord/alpha-nvim',

	config = function()
		local app = require 'util.app'
		local mathu = require 'util.math'

		local alpha = require 'alpha'
		local dashboard = require 'alpha.themes.dashboard'

		dashboard.section.header.val = {
			[[                                               ██                  ]],
			[[      ████ ██████           █████  █████ ███                  ]],
			[[     ███████████             █████ █████                       ]],
			[[    ████████████████████████████████ ███ ████████████ ]],
			[[   ███████████████    ███████████████ ████ ████████████████ ]],
			[[  █████████████████████ ███████████ ████ ██████████████ ]],
			[[ █████ █████████    ███ ███████████ ████ █████ ████ █████ ]],
			[[█████   █████████████████████ ███████ ███████████████]],
		}

		local function button(...)
			local args = { ... }
			args[3] = ':silent! ' .. args[3]
			return dashboard.button(unpack(args))
		end

		local cd_path = app.os() == 'windows' and '/' or '~'

		dashboard.section.buttons.val = {
			button('e', '  explore', 'Neotree filesystem<CR>'),
			button('o', '󰮗  old files', 'Telescope oldfiles<CR>'),
			button('n', '󰯁  edit new', 'ene <BAR> startinsert<CR>'),
			button('f', '󰈞  find files', 'Telescope find_files<CR>'),
			button('c', '  change dir', string.format('Neotree filesystem current %s reveal_force_cwd<CR>', cd_path)),
			button('l', '󰒲  lazy', 'Lazy<CR>'),
			button('m', '󰏗  mason', 'Mason<CR>'),
			button('t', '󰏘  theme', 'PickColorScheme<CR>'),
			button('q', '  quit', 'qa<CR>'),
		}

		local small_height = 35
		local win_height = vim.fn.winheight(0)
		local zoom_factor = mathu.clamp(win_height, 0, small_height) / small_height
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
