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
					{ 'Recent Files', 'Telescope oldfiles' },
					{ 'Find Files', 'Telescope find_files' },
					{ 'Change Directory', string.format('Neotree filesystem current %s', app.os() == 'windows' and '/' or '~') },
				}),
				section('Editor', {
					{ 'New Buffer', 'enew' },
					{ 'Theme', 'PickColorScheme' },
					{ 'Quit', 'wa | qa!' },
				}),
				section('Workspaces', function()
					local ok, workspaces = pcall(require, 'workspaces')
					if not ok then
						return
					end

					return array.concat(
						{
							{ 'Open Workspace', 'WorkspacesOpen' },
						},
						array.map(array.take(workspaces.get(), 5), function(ws, index)
							return {
								string.format('%d. %s', index, ws.name),
								string.format('WorkspacesOpen %s', ws.name),
							}
						end)
					)
				end),
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
			}, '\n'),

			footer = '',
		}
	end,
}
