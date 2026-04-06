return {
	'nvim-mini/mini.files',

	lazy = false,

	opts = {
		mappings = {
			close = 'q',
			go_in_plus = 'l',
			go_out = 'h',
			mark_goto = "'",
			mark_set = 'm',
			synchronize = '=',
			go_in = '',
			go_out_plus = '',
			reset = '',
			reveal_cwd = '',
			show_help = '',
			trim_left = '',
			trim_right = '',
		},

		options = {
			permanent_delete = true,
			use_as_default_explorer = true,
		},

		content = {
			prefix = function(fs_entry)
				local icon, hl = MiniFiles.default_prefix(fs_entry)
				return ' ' .. icon, hl
			end,
		},
	},

	config = function(_, opts)
		local autocmd = require 'util.autocmd'
		local MiniFiles = require 'mini.files'
		local keymap = require 'mappet'

		local map = keymap.map
		local keys = keymap.group 'plugins.ui.mini.files'
		local file_keys = keymap.template()

		MiniFiles.setup(opts)

		keys('Files: %s', { 'n' }) {
			map('<Leader>e', 'open') {
				function()
					if not MiniFiles.close() then
						local buf_name = vim.api.nvim_buf_get_name(0)
						local file_path = vim.fn.filereadable(buf_name) == 1 and buf_name or nil
						MiniFiles.open(file_path or MiniFiles.get_latest_path(), true)
						MiniFiles.reveal_cwd()
					end
				end,
			},
		}

		file_keys('Files: %s', { 'n', remap = true, nowait = true }) {
			map('<Esc>', 'close') 'q',
			map('<CR>', 'open') 'l',

			map('<LocalLeader>w', 'synchronize') '=',

			map('<Leader>', 'leader passthrough') 'q<Cmd>silent! WhichKey<CR><Leader>',

			map('g.', 'go to cwd') '<Cmd>MiniFilesCwd<CR>',
			map('gd', 'cd') ':MiniFilesCwd<C-b>tcd  | <S-Left><Left>',
			map('gz', 'zoxide') 'q:<C-b>Tz ',

			map('c.', 'set cwd') {
				function()
					local path = (MiniFiles.get_fs_entry() or {}).path
					if path then
						local cwd = vim.fs.dirname(path)
						vim.cmd.tcd(cwd)
						MiniFiles.open(cwd, false)
					end
				end,
			},

			map('gx', 'system open') {
				function()
					vim.ui.open(MiniFiles.get_fs_entry().path)
				end,
			},
		}

		vim.api.nvim_create_user_command('MiniFilesCwd', function()
			MiniFiles.open(vim.fn.getcwd(), false)
		end, {})

		local augroup = autocmd.group 'mini.files'

		augroup:on_user('MiniFilesBufferCreate', function(event)
			file_keys:apply(keymap.buffer('mini.files', event.data.buf_id))
		end)

		augroup:on_user('ZoxideDirChanged', 'MiniFilesCwd')
	end,
}
