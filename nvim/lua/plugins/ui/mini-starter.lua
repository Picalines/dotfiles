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
				local icon, item_name, action = item[1], item[2], item[3]
				return { section = name, name = item_name, action = action, __icon = icon }
			end)
		end

		starter.setup {
			autoopen = true,

			evaluate_single = true,

			silent = true,

			items = {
				section('Files', {
					{ '', 'Explore Files', 'Neotree filesystem reveal' },
					{ '', 'Change Directory', string.format('Neotree filesystem current %s', app.os() == 'windows' and '/' or '~') },
					{ '󰣩', 'Open Workspace', 'WorkspacesOpen' },
				}),
				section('Editor', {
					{ '󱇨', 'New Buffer', 'enew' },
					{ '󰸌', 'Theme', 'PickColorScheme' },
					{ '', 'Font', 'PickGuiFont' },
					{ '', 'Quit', 'wa | qa!' },
				}),
				section('Manage', {
					{ '󰒲', 'Lazy', 'Lazy' },
					{ '󰏗', 'Mason', 'Mason' },
					{ '', 'Health', 'checkhealth' },
				}),
			},

			content_hooks = {
				function(content)
					local coords = MiniStarter.content_coords(content, 'item')
					for i = #coords, 1, -1 do
						local l_num, u_num = coords[i].line, coords[i].unit
						local item = content[l_num][u_num].item
						table.insert(content[l_num], u_num, {
							string = item.__icon .. ' ',
							type = 'item_bullet',
							hl = 'MiniStarterItemBullet',
							_item = item,
							_place_cursor = true,
						})
					end

					return content
				end,

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
