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

		---@param section_name string
		---@param child_items StarterItem[] | (fun(): StarterItem[] | nil)
		local function new_section(section_name, child_items)
			if type(child_items) == 'function' then
				child_items = child_items() or {}
			end

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
					{ 'Explore Files', 'Neotree filesystem reveal' },
					{ 'Recent Files', 'Telescope oldfiles' },
					{ 'Find Files', 'Telescope find_files' },
					{ 'Change Directory', string.format('Neotree filesystem current %s', app.os() == 'windows' and '/' or '~') },
				}),
				new_section('Editor', {
					{ 'New Buffer', 'enew' },
					{ 'Theme', 'PickColorScheme' },
					{ 'Quit', 'wa | qa!' },
				}),
				new_section('Workspaces', function()
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
				new_section('Manage', {
					{ 'Lazy', 'Lazy' },
					{ 'Mason', 'Mason' },
				}),
			},

			silent = false,

			content_hooks = {
				starter.gen_hook.adding_bullet ' ',
				starter.gen_hook.aligning('center', 'center'),
			},

			header = function()
				return table.concat({
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
				}, '\n')
			end,

			footer = '',
		}
	end,
}
