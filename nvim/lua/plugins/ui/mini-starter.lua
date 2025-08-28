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
					{ 'Open Workspace 󰣩', 'WorkspacesOpen' },
					{ 'Explore Files ', 'Neotree filesystem current' },
					{ 'Find Files ', 'lua Snacks.picker.files()' },
				}),
				section('Editor', {
					{ 'New Buffer 󱇨', 'enew' },
					{ 'Theme 󰸌', 'lua Snacks.picker.colorschemes()' },
					{ 'Quit ', 'wa | qa!' },
				}),
				section('Manage', {
					{ 'Lazy 󰒲', 'Lazy' },
					{ 'Mason 󰏗', 'Mason' },
					{ 'Health ', 'checkhealth' },
				}),
			},

			content_hooks = {
				starter.gen_hook.adding_bullet('░ ', true),
				starter.gen_hook.aligning('center', 'center'),
			},

			header = (function()
				local random_chars = { '☕', '✨', '🎒', '🎨', '🎯', '💤', '📚', '🧠' }
				return string.format('Neovim %s v%s', random_chars[math.random(1, #random_chars)], vim.version())
			end)(),

			footer = '||',
		}
	end,
}
