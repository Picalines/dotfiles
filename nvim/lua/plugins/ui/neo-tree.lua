local app = require 'util.app'
local autocmd = require 'util.autocmd'
local func = require 'util.func'
local keymap = require 'util.keymap'

keymap {
	[{ 'n', silent = true }] = {
		['<leader>e'] = { '<Cmd>Neotree focus filesystem<CR>', 'File explorer' },
	},
}

local augroup = autocmd.group 'neo-tree'

augroup:on_user('ColorSchemePatch', function()
	local hl = require 'util.highlight'
	hl.link('NeoTreeWinSeparator', 'WinSeparator')
end)

return {
	'nvim-neo-tree/neo-tree.nvim',

	lazy = vim.fn.argc() == 0,
	cmd = 'Neotree',

	dependencies = {
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		'nvim-tree/nvim-web-devicons',
	},

	---@module 'neo-tree'
	---@module 'nui.tree'
	---@type neotree.Config
	opts = {
		sources = { 'filesystem' },

		close_if_last_window = false,
		popup_border_style = 'rounded',

		hide_root_node = true,
		enable_git_status = true,

		event_handlers = {
			{
				event = 'file_open_requested',
				handler = function()
					require('neo-tree.command').execute { action = 'close' }
				end,
			},
		},

		default_component_configs = {
			container = {
				enable_character_fade = true,
			},
			indent = {
				indent_size = 2,
				padding = 0,

				with_markers = true,
				indent_marker = '│',
				last_indent_marker = '└',

				with_expanders = false,
			},
			icon = {
				folder_closed = '',
				folder_open = '',
				folder_empty = '',
				folder_empty_open = '',
				default = '',
			},
			modified = {
				symbol = '+',
				highlight = '@diff.plus',
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
			},
			git_status = {
				symbols = {
					unstaged = '',
					staged = '',
					added = '󰻭',
					deleted = '󱀷',
					modified = '󱇨',
					renamed = '󱀱',
					conflict = '󱪖',
					untracked = '󰱽',
					ignored = '',
				},
			},
			file_size = {
				enabled = false,
				required_width = 64,
			},
			type = {
				enabled = false,
				required_width = 122,
			},
			---@diagnostic disable-next-line: missing-fields
			last_modified = { enabled = false },
			---@diagnostic disable-next-line: missing-fields
			created = { enabled = false },
			---@diagnostic disable-next-line: missing-fields
			symlink_target = { enabled = false },
		},

		window = {
			position = 'left',

			---@diagnostic disable-next-line: assign-type-mismatch
			width = '25%',

			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				['<leader>e'] = func.cmd 'Neotree close filesystem',
				['<C-o>'] = func.cmd 'wincmd p',
				['<C-w>c'] = func.cmd 'Neotree close filesystem',

				-- default maps
				['<esc>'] = 'noop',
				['?'] = 'noop',
				['/'] = 'noop',

				['f'] = func.cmd 'lua Snacks.picker.files()',

				['<cr>'] = 'open',
				['<2-LeftMouse>'] = 'open',
				['l'] = 'open',
				['h'] = 'close_node',
				['v'] = 'open_vsplit',
				['V'] = 'open_split',

				['t'] = 'open_tabnew',
				-- ['h'] = 'close_all_subnodes',
				-- ["<cr>"] = "open_drop",

				['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
				['L'] = 'focus_preview',

				['z'] = 'close_all_nodes',
				['Z'] = 'expand_all_nodes',

				['a'] = 'add',
				['d'] = 'delete',
				['r'] = 'rename',
				['c'] = 'copy_to_clipboard',
				['x'] = 'cut_to_clipboard',
				['p'] = 'paste_from_clipboard',
				['m'] = 'move',
				['i'] = 'show_file_details',

				['q'] = 'close_window',
				['R'] = 'refresh',
				['<'] = 'prev_source',
				['>'] = 'next_source',
			},
		},

		filesystem = {
			group_empty_dirs = false,
			hijack_netrw_behavior = 'open_current',

			-- temp fix, see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/914
			use_libuv_file_watcher = app.os() ~= 'windows',

			bind_to_cwd = true,
			cwd_target = {
				sidebar = 'tab',
				current = 'tab',
			},

			filtered_items = {
				visible = false,
				hide_dotfiles = false,
				hide_gitignored = true,
				hide_hidden = false,
				hide_by_name = { '.git' },
				never_show = {
					'.DS_Store',
					'thumbs.db',
					'$RECYCLE.BIN',
					'System Volume Information',
				},
			},

			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},

			window = {
				mappings = {
					['<bs>'] = 'navigate_up',
					['.'] = 'set_root',

					['H'] = 'toggle_hidden',

					['[c'] = 'prev_git_modified',
					[']c'] = 'next_git_modified',

					['!'] = 'run_command',
					['gx'] = 'system_open',

					['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
					['oc'] = { 'order_by_created', nowait = false },
					['od'] = { 'order_by_diagnostics', nowait = false },
					['og'] = { 'order_by_git_status', nowait = false },
					['om'] = { 'order_by_modified', nowait = false },
					['on'] = { 'order_by_name', nowait = false },
					['os'] = { 'order_by_size', nowait = false },
					['ot'] = { 'order_by_type', nowait = false },
				},
			},

			commands = {
				run_command = function(state)
					local node = state.tree:get_node()
					if node then
						vim.api.nvim_input(':! ' .. vim.fn.fnamemodify(node:get_id(), ':p:.') .. '<Home><Right>')
					end
				end,

				system_open = function(state)
					local node = state.tree:get_node()
					if node then
						vim.ui.open(vim.fn.fnamemodify(node:get_id(), ':p:.'))
					end
				end,
			},
		},
	},
}
