return {
	'nvim-neo-tree/neo-tree.nvim',

	branch = 'v3.x',

	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
		'MunifTanjim/nui.nvim',
		{
			's1n7ax/nvim-window-picker',
			version = '2.*',
			config = function()
				require('window-picker').setup {
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						bo = {
							filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
							buftype = { 'terminal', 'quickfix' },
						},
					},
				}
			end,
		},
	},

	config = function()
		local cmds = require('keymaps.util').cmds

		require('neo-tree').setup {
			close_if_last_window = false,
			popup_border_style = 'rounded',

			enable_git_status = true,
			enable_diagnostics = true,

			hide_root_node = true,

			enable_normal_mode_for_inputs = false,

			open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },

			sort_case_insensitive = false,

			nesting_rules = {},

			source_selector = {
				winbar = true,
				statusline = false,
				show_scrolled_off_parent_node = false,

				sources = {
					{ source = 'filesystem' },
					{ source = 'buffers' },
					{ source = 'git_status' },
				},

				content_layout = 'center',
				tabs_layout = 'equal',

				highlight_tab = 'NeoTreeTabInactive',
				highlight_tab_active = 'NeoTreeTabActive',
				highlight_background = 'NeoTreeTabInactive',
				highlight_separator = 'NeoTreeTabSeparatorInactive',
				highlight_separator_active = 'NeoTreeTabSeparatorActive',
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
					highlight = 'NeoTreeIndentMarker',

					with_expanders = false,
					-- expander_collapsed = '',
					-- expander_expanded = '',
					-- expander_highlight = 'NeoTreeExpander',
				},
				icon = {
					folder_closed = '',
					folder_open = '',
					folder_empty = '󰜌',

					default = '',
					highlight = 'NeoTreeFileIcon',
				},
				modified = {
					symbol = '',
					highlight = 'NeoTreeModified',
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = 'NeoTreeFileName',
				},
				git_status = {
					symbols = {
						added = '✚',
						modified = '',
						conflict = '',
						unstaged = '󰏫',
						staged = '✓',
						renamed = '➜',
						untracked = '+',
						deleted = '-',
						ignored = '◌',
					},
				},
				file_size = {
					enabled = true,
					required_width = 64, -- min width of window required to show this column
				},
				type = {
					enabled = true,
					required_width = 122, -- min width of window required to show this column
				},
				last_modified = {
					enabled = true,
					required_width = 88, -- min width of window required to show this column
				},
				created = {
					enabled = true,
					required_width = 110, -- min width of window required to show this column
				},
				symlink_target = {
					enabled = false,
				},
			},

			commands = {},
			window = {
				position = 'left',
				width = 40,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					['<leader>e'] = cmds ':wincmd p',

					['<esc>'] = 'cancel', -- close preview or floating neo-tree window

					['<cr>'] = 'open',
					['<2-LeftMouse>'] = 'open',
					['l'] = 'open',
					['w'] = 'open_with_window_picker',
					['h'] = 'close_node',
					['S'] = 'open_split',
					['s'] = 'open_vsplit',
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
					['?'] = 'show_help',
					['<'] = 'prev_source',
					['>'] = 'next_source',
				},
			},

			filesystem = {
				group_empty_dirs = false,
				hijack_netrw_behavior = 'open_default',
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_hidden = false, -- windows
					hide_by_name = {
						-- "node_modules"
					},
					hide_by_pattern = {
						-- "*.meta",
						-- "*/src/*/tsconfig.json",
					},
					always_show = {
						-- ".gitignored",
					},
					never_show = {
						'.DS_Store',
						'thumbs.db',
					},
					never_show_by_pattern = {
						-- ".null-ls_*",
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
						['/'] = 'fuzzy_finder',

						['[c'] = 'prev_git_modified',
						[']c'] = 'next_git_modified',

						-- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
						-- ['oc'] = { 'order_by_created', nowait = false },
						-- ['od'] = { 'order_by_diagnostics', nowait = false },
						-- ['og'] = { 'order_by_git_status', nowait = false },
						-- ['om'] = { 'order_by_modified', nowait = false },
						-- ['on'] = { 'order_by_name', nowait = false },
						-- ['os'] = { 'order_by_size', nowait = false },
						-- ['ot'] = { 'order_by_type', nowait = false },
					},
					fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
						['<down>'] = 'move_cursor_down',
						['<C-n>'] = 'move_cursor_down',
						['<up>'] = 'move_cursor_up',
						['<C-p>'] = 'move_cursor_up',
					},
				},

				commands = {},
			},

			buffers = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				group_empty_dirs = true,
				show_unloaded = true,
				window = {
					mappings = {
						['bd'] = 'buffer_delete',
						['<bs>'] = 'navigate_up',
						['.'] = 'set_root',
					},
				},
			},

			git_status = {
				window = {
					position = 'float',
					mappings = {
						['ga'] = 'git_add_file',
						['gA'] = 'git_add_all',
						['gu'] = 'git_unstage_file',
						['gr'] = 'git_revert_file',
						['gc'] = 'git_commit',
						['gp'] = 'git_push',
						['gg'] = 'git_commit_and_push',

						-- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
						-- ['oc'] = { 'order_by_created', nowait = false },
						-- ['od'] = { 'order_by_diagnostics', nowait = false },
						-- ['om'] = { 'order_by_modified', nowait = false },
						-- ['on'] = { 'order_by_name', nowait = false },
						-- ['os'] = { 'order_by_size', nowait = false },
						-- ['ot'] = { 'order_by_type', nowait = false },
					},
				},
			},
		}

		vim.keymap.set('n', '<leader>e', ':Neotree reveal=true source=last<CR>', { desc = 'Jump to File [E]xplorer', silent = true })
		vim.keymap.set('n', '<leader>E', ':Neotree toggle=true source=last<CR>', { desc = 'Toggle File [E]xplorer', silent = true })
	end,
}
