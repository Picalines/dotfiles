return {
	'echasnovski/mini.starter',

	lazy = false,

	config = function()
		local app = require 'util.app'
		local array = require 'util.array'
		local starter = require 'mini.starter'

		---@class StarterItem
		---@field [1] string name
		---@field [2] string action

		---@param name string
		---@param items StarterItem[] | (fun(): StarterItem[] | nil)
		local function section(name, items)
			if type(items) == 'function' then
				items = items() or {}
			end

			return array.map(items, function(item)
				local item_name, action = item[1], item[2]
				return { section = name, name = item_name, action = action }
			end)
		end

		starter.setup {
			autoopen = true,

			evaluate_single = true,

			silent = true,

			items = {
				section('Files', {
					{ 'Explore Files', 'Neotree filesystem reveal' },
					{ 'Change Directory', string.format('Neotree filesystem current %s', app.os() == 'windows' and '/' or '~') },
					{ 'Open Workspace', 'WorkspacesOpen' },
				}),
				section('Editor', {
					{ 'New Buffer', 'enew' },
					{ 'Theme', 'PickColorScheme' },
					{ 'Font', 'PickGuiFont' },
					{ 'Quit', 'wa | qa!' },
				}),
				section('Manage', {
					{ 'Lazy', 'Lazy' },
					{ 'Mason', 'Mason' },
				}),
			},

			content_hooks = {
				starter.gen_hook.adding_bullet ' ',
				starter.gen_hook.aligning('center', 'center'),
			},

			header = table.concat({
				[[                                                     ]],
				[[   ██ █        ██       ██       █         █       ██ █    ]],
				[[  ███ █       ██     ██     █           █     ██ █    ]],
				[[ ███ █      ██ █   █  █   █            ██   ██ █    ]],
				[[███ █ ██ █ █    █ █      ██ █████]],
				[[██ ██ █ █  █    █ ██ █   █ ██      █]],
				[[    ███   █ █      █  █  ██ █  █   ██            █ ]],
				[[    ███     █      ██   █  █     █           █  ]],
				[[    ██       █          ██     ████       █         █   ]],
				[[                                                         ]],
				'',
				string.format('v%s', vim.version()),
			}, '\n'),

			footer = '',
		}
	end,
}
