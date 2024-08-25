return {
	'echasnovski/mini.starter',

	lazy = false,

	config = function()
		local app = require 'util.app'
		local array = require 'util.array'
		local starter = require 'mini.starter'

		---@param section_name string
		---@param child_items string[][]
		local function new_section(section_name, child_items)
			return array.map(child_items, function(item)
				local name, action = item[1], item[2]
				return { section = section_name, name = name, action = action }
			end)
		end

		starter.setup {
			autoopen = true,

			evaluate_single = true,

			items = {
				new_section('Files', {
					{ 'Old Files', 'Telescope oldfiles' },
					{ 'Find Files', 'Telescope find_files' },
					{ 'Change Directory', string.format('Neotree filesystem current %s', app.os() == 'windows' and '/' or '~') },
				}),
				new_section('Editor', {
					{ 'New Buffer', 'enew' },
					{ 'Quit', 'wqa!' },
				}),
				new_section('Manage', {
					{ 'Lazy', 'Lazy' },
					{ 'Mason', 'Mason' },
					{ 'Theme', 'PickColorScheme' },
				}),
			},

			silent = false,

			content_hooks = {
				starter.gen_hook.adding_bullet(),
				starter.gen_hook.aligning('center', 'center'),
			},

			header = function()
				return table.concat({
					[[                                    █                      ]],
					[[   ██  █        ██        ██          █         █       ██  █    ]],
					[[  ██  █       ██      ██        █          ██     ██  █    ]],
					[[ █ █  █      ██ █    █  █      █          ████   █ █       ]],
					[[█  █        ██ █  █  █    █    █    ███  █  ████ ]],
					[[  █ █  █ █   █  █   █  █  █ ███            █ ]],
					[[     ██    █ █       █  █   █  █  ████            █  ]],
					[[     ██      █       ██    █   █    ██            █   ]],
					[[     █        █           ██      █████      █           █    ]],
					[[                                 ███                        ]],
				}, '\n')
			end,

			footer = '',
		}
	end,
}
