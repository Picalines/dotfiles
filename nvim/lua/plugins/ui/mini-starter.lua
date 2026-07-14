return {
	'nvim-mini/mini.starter',

	lazy = false,

	config = function()
		local starter = require 'mini.starter'

		local function section(name, items)
			return vim
				.iter(items)
				:map(function(item)
					local item_name, cmd = item[1], item[2]
					return { section = name, name = item_name, action = cmd }
				end)
				:totable()
		end

		starter.setup {
			autoopen = true,

			evaluate_single = true,

			silent = true,

			items = {
				section('Files', {
					{ 'Explore ', 'e .' },
					{ 'Find ', 'lua Snacks.picker.files()' },
					{ 'Grep ', 'lua Snacks.picker.grep()' },
					{ 'New 󱇨', 'enew' },
				}),
				section('Editor', {
					{ 'Health ', 'checkhealth' },
					{ 'Lazy 󰒲', 'Lazy' },
					{ 'Quit ', 'wa | qa!' },
				}),
			},

			content_hooks = {
				starter.gen_hook.adding_bullet('░ ', true),
				starter.gen_hook.aligning('center', 'center'),
			},

			header = (function()
				local random_chars = { '☕', '✨', '🎒', '🎨', '🎯', '💤', '📚', '🧠' }
				return string.format('Neovim %s %s', vim.version().build, random_chars[math.random(1, #random_chars)])
			end)(),

			footer = '||',
		}
	end,
}
