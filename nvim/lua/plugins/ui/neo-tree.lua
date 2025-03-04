local keymap = require 'util.keymap'

keymap.declare {
	[{ 'n', silent = true }] = {
		['<leader>e'] = { '<Cmd>Neotree focus filesystem<CR>', 'File explorer' },
	},
}

return {
	'nvim-neo-tree/neo-tree.nvim',

	lazy = vim.fn.argc() == 0,
	cmd = 'Neotree',

	dependencies = {
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		'nvim-tree/nvim-web-devicons',
	},

	config = function()
		local app = require 'util.app'
		local autocmd = require 'util.autocmd'
		local func = require 'util.func'
		local nt_fs = require 'neo-tree.sources.filesystem.commands'
		local signal = require 'util.signal'
		local str = require 'util.string'
		local win = require 'util.window'

		local sidebar_width = signal.new(40)
		signal.persist(sidebar_width, str.fmt(app.client(), '.plugin.neo-tree.sidebar_width'))

		local augroup = autocmd.group 'neo-tree'

		augroup:on_winresized(function(event)
			if #vim.v.event.windows <= 1 then
				return
			end

			local filetype = vim.api.nvim_get_option_value('filetype', { buf = event.buf })
			if filetype == 'neo-tree' and win.layout_type(event.win) == 'row' then
				sidebar_width(math.min(vim.api.nvim_win_get_width(event.win), vim.go.columns - 20))
			end
		end)

		require('neo-tree').setup {
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
					default = '',
				},
				modified = {
					symbol = '+',
					highlight = 'DiffAdd',
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

			window = {
				position = 'left',

				width = func.curry_only(sidebar_width),

				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					['<leader>e'] = func.cmd 'Neotree close filesystem',
					['<C-o>'] = func.cmd 'wincmd p',
					['<C-w>c'] = func.cmd 'Neotree close filesystem',

					['<esc>'] = 'cancel',

					['<cr>'] = 'open',
					['<2-LeftMouse>'] = 'open',
					['l'] = 'open',
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

					['}'] = function() end, -- prevents me from switching buffer accidentally
					['{'] = function() end,
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
						['/'] = 'set_root',

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
					set_root = function(state)
						nt_fs.set_root(state)

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
						vim.api.nvim_input(':! ' .. path .. '<Home><Right>')
					end,
					system_open = function(state)
						local node = state.tree:get_node()
						local path = vim.fn.fnamemodify(node:get_id(), ':p:.')
						vim.ui.open(path)
					end,
				},
			},
		}
	end,
}
