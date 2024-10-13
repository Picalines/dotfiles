return {
	'nvim-neo-tree/neo-tree.nvim',

	dependencies = {
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		'nvim-tree/nvim-web-devicons',
	},

	config = function()
		-- FIXME: there's a bug when you use the :cd command without anything else

		local app = require 'util.app'
		local autocmd = require 'util.autocmd'
		local func = require 'util.func'
		local hl = require 'util.highlight'
		local keymap = require 'util.keymap'
		local nt_fs = require 'neo-tree.sources.filesystem.commands'
		local signal = require 'util.signal'

		keymap.declare {
			[{ 'n', silent = true }] = {
				['<leader>e'] = { '<Cmd>Neotree focus filesystem<CR>', 'File explorer' },
			},
		}

		local sidebar_width = signal.new(40)
		signal.persist(sidebar_width, 'plugin.neo-tree.sidebar_width')

		autocmd.on('WinResized', '*', function(event)
			local filetype = vim.api.nvim_buf_get_option(event.buf, 'filetype')
			local winid = tonumber(event.match)
			if filetype == 'neo-tree' and winid and #vim.api.nvim_list_wins() > 1 then
				sidebar_width(vim.api.nvim_win_get_width(winid))
			end
		end)

		autocmd.on_colorscheme('*', function()
			vim.api.nvim_set_hl(0, 'NeoTreeModified', { fg = hl.attr('@diff.plus', 'fg'), bg = 'NONE' })
		end)

		require('neo-tree').setup {
			sources = { 'filesystem' },

			close_if_last_window = false,
			popup_border_style = 'rounded',

			hide_root_node = true,
			enable_git_status = true,

			event_handlers = {
				{
					event = 'neo_tree_window_after_open',
					handler = function(event)
						if event.position ~= 'current' then
							vim.api.nvim_set_option_value('winfixbuf', true, { win = event.winid, scope = 'local' })
						end
					end,
				},
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
					folder_closed = '',
					folder_open = '',
					folder_empty = '󰜌',
					default = '',
				},
				modified = {
					symbol = '+',
					highlight = 'NeoTreeModified',
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
				},
			},

			filesystem = {
				group_empty_dirs = false,
				hijack_netrw_behavior = 'open_default',

				-- temp fix, see https://github.com/nvim-neo-tree/neo-tree.nvim/issues/914
				use_libuv_file_watcher = app.os() ~= 'windows',
				bind_to_cwd = true,

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
						if app.os() == 'linux' then
							error 'not implemented'
						end
						local cmd = app.os() == 'macos' and 'open' or 'explorer.exe'
						local node = state.tree:get_node()
						local path = vim.fn.fnamemodify(node:get_id(), ':p:.')
						vim.api.nvim_input(string.format('<Cmd>!%s %s<CR>', cmd, path))
					end,
				},
			},
		}
	end,
}
