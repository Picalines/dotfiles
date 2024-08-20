return {
	'nvim-neo-tree/neo-tree.nvim',

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

		'mrbjarksen/neo-tree-diagnostics.nvim',
	},

	config = function()
		local app = require 'util.app'
		local keymap = require 'util.keymap'
		local func = require 'util.func'

		keymap.declare {
			[{ 'n', silent = true }] = {
				['<leader>e'] = { '<Cmd>Neotree focus filesystem<CR>', 'File explorer' },
				['<leader>g'] = { '<Cmd>Neotree focus git_status float<CR>', 'Git tree' },
				['<C-w>D'] = { '<Cmd>Neotree focus diagnostics bottom<CR>', 'Diagnostics list' },
			},
		}

		local fs_actions = require 'neo-tree.sources.filesystem.commands'
		local events = require 'neo-tree.events'
		local popups = require 'neo-tree.ui.popups'
		local inputs = require 'neo-tree.ui.inputs'

		require('neo-tree').setup {
			sources = {
				'filesystem',
				'git_status',
				'diagnostics',
			},

			close_if_last_window = false,
			popup_border_style = 'rounded',

			enable_git_status = true,
			enable_diagnostics = true,

			hide_root_node = true,

			open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },

			sort_case_insensitive = false,

			source_selector = {
				winbar = false,
				statusline = false,
				show_scrolled_off_parent_node = false,

				sources = {
					{ source = 'filesystem' },
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
					symbol = '+',
					highlight = '@diff.plus',
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = 'NeoTreeFileName',
				},
				git_status = {
					symbols = {
						added = '',
						modified = '',
						conflict = '',
						unstaged = '',
						staged = '',
						renamed = '',
						untracked = '',
						deleted = '',
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
				last_modified = {
					enabled = false,
					required_width = 88,
				},
				created = {
					enabled = false,
					required_width = 110,
				},
				symlink_target = {
					enabled = false,
				},
			},

			event_handlers = {
				{
					event = 'file_open_requested',
					handler = function()
						require('neo-tree.command').execute { action = 'close' }
					end,
				},
			},

			window = {
				position = 'left',
				width = 40,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					['<leader>e'] = func.cmd ':Neotree close filesystem',
					['<C-o>'] = func.cmd ':wincmd p',

					['<esc>'] = 'cancel',

					['<cr>'] = 'open',
					['<2-LeftMouse>'] = 'open',
					['l'] = 'open',
					['w'] = 'open_with_window_picker',
					['h'] = 'close_node',
					['v'] = 'open_vsplit',
					['V'] = 'open_split',
					['s'] = 'noop', -- leap.nvim
					['S'] = 'noop',

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

				-- temp fix, see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/914
				use_libuv_file_watcher = app.os() ~= 'windows',
				bind_to_cwd = true,

				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_hidden = false, -- windows
					hide_by_name = {
						-- "node_modules"
						'.git',
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
						'$RECYCLE.BIN',
						'System Volume Information',
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
						['/'] = 'set_root',

						['H'] = 'toggle_hidden',
						['f'] = 'fuzzy_finder',

						['[c'] = 'prev_git_modified',
						[']c'] = 'next_git_modified',

						['.'] = 'run_command',

						['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
						['oc'] = { 'order_by_created', nowait = false },
						['od'] = { 'order_by_diagnostics', nowait = false },
						['og'] = { 'order_by_git_status', nowait = false },
						['om'] = { 'order_by_modified', nowait = false },
						['on'] = { 'order_by_name', nowait = false },
						['os'] = { 'order_by_size', nowait = false },
						['ot'] = { 'order_by_type', nowait = false },
					},

					fuzzy_finder_mappings = {
						['<down>'] = 'move_cursor_down',
						['<C-j>'] = 'move_cursor_down',
						['<C-n>'] = 'move_cursor_down',
						['<up>'] = 'move_cursor_up',
						['<C-k>'] = 'move_cursor_up',
						['<C-p>'] = 'move_cursor_up',
					},
				},

				commands = {
					navigate_up = function(state)
						fs_actions.navigate_up(state)

						local cwd = vim.fn.getcwd()
						local cwd_parent = vim.fn.fnamemodify(cwd, ':h')
						vim.api.nvim_set_current_dir(cwd_parent)
					end,
					set_root = function(state)
						fs_actions.set_root(state)

						local tree = state.tree
						local node = tree:get_node()
						local root = node.path

						if node.type == 'file' then
							root = vim.fn.fnamemodify(root, ':h')
						end

						vim.api.nvim_set_current_dir(root)
					end,
					run_command = function(state)
						local node = state.tree:get_node()
						local path = vim.fn.fnamemodify(node:get_id(), ':p:.')
						vim.api.nvim_input(': ' .. path .. '<Home>')
					end,
				},
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

			diagnostics = {
				auto_preview = {
					enabled = false,
					preview_config = {},
					event = 'neo_tree_buffer_enter',
				},
				bind_to_cwd = true,
				diag_sort_function = 'severity',
				follow_current_file = {
					enabled = true,
					always_focus_file = false,
					expand_followed = true,
					leave_dirs_open = false,
					leave_files_open = false,
				},
				group_dirs_and_files = true,
				group_empty_dirs = true,
				show_unloaded = true,
				refresh = {
					delay = 100,
					event = 'vim_diagnostic_changed',
					max_items = 10000,
				},
				window = {
					mappings = {
						['q'] = func.cmd ':Neotree close diagnostics',
						['<C-w>D'] = func.cmd ':Neotree close diagnostics',
					},
				},
			},

			git_status = {
				window = {
					mappings = {
						['ga'] = 'git_add_file',
						['gA'] = 'git_add_all',
						['gu'] = 'git_unstage_file',
						['gr'] = 'git_revert_file',
						['gc'] = 'git_commit',
						['gC'] = 'git_commit_amend',
						['gp'] = 'git_pull',
						['gP'] = 'git_push',

						['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
						['oc'] = { 'order_by_created', nowait = false },
						['od'] = { 'order_by_diagnostics', nowait = false },
						['om'] = { 'order_by_modified', nowait = false },
						['on'] = { 'order_by_name', nowait = false },
						['os'] = { 'order_by_size', nowait = false },
						['ot'] = { 'order_by_type', nowait = false },
					},
				},

				commands = {
					git_pull = function()
						local result = vim.fn.systemlist { 'git', 'pull' }
						events.fire_event(events.GIT_EVENT)
						popups.alert('git pull', result)
					end,
					git_commit = function(_)
						-- NOTE: i've changed the default git_commit, because i don't know
						-- why they've made the message input popup misaligned :(
						local popup_options = {
							relative = 'win',
							size = vim.fn.winwidth(0) - 2,
							position = { row = vim.api.nvim_win_get_height(0) - 2, col = 1 },
						}

						inputs.input('Commit message', '', function(msg)
							local commit_result = vim.fn.systemlist { 'git', 'commit', '-m', msg }
							if vim.v.shell_error ~= 0 or (#commit_result > 0 and vim.startswith(commit_result[1], 'fatal:')) then
								popups.alert('ERROR: git commit', commit_result)
								return
							end
							events.fire_event(events.GIT_EVENT)
							popups.alert('git commit', commit_result)
						end, popup_options)
					end,
					git_commit_amend = function()
						local popup_options = {
							relative = 'win',
							size = vim.fn.winwidth(0) - 2,
							position = { row = vim.api.nvim_win_get_height(0) - 2, col = 1 },
						}

						local message = tostring(vim.fn.system { 'git', 'show', '-s', '--format=%s' })
						message = message:gsub('\n$', '') -- NOTICE: input() immediately returns if str ends with \n

						inputs.input('Amend message', message, function(new_message)
							local amend_result = vim.fn.systemlist { 'git', 'commit', '--amend', '-m', new_message }
							if vim.v.shell_error ~= 0 or (#amend_result > 0 and vim.startswith(amend_result[1], 'fatal:')) then
								popups.alert('ERROR: git commit --amend', amend_result)
								return
							end
							events.fire_event(events.GIT_EVENT)
							popups.alert('git commit --amend', amend_result)
						end, popup_options)
					end,
				},
			},
		}
	end,
}
