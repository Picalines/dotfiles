return {
	'nvim-mini/mini.files',

	lazy = false,

	opts = {
		mappings = {
			close = 'q',
			go_in = '',
			go_in_plus = 'l',
			go_out = 'h',
			go_out_plus = '',
			mark_goto = "'",
			mark_set = 'm',
			reset = '<BS>',
			reveal_cwd = '',
			show_help = 'g?',
			synchronize = '=',
			trim_left = '<',
			trim_right = '>',
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
		local keymap = require 'util.keymap'

		MiniFiles.setup(opts)

		keymap {
			[{ 'n', desc = 'Files: %s' }] = {
				['<Leader>e'] = {
					desc = 'open',
					function()
						if not MiniFiles.close() then
							local buf_name = vim.api.nvim_buf_get_name(0)
							local file_path = vim.fn.filereadable(buf_name) == 1 and buf_name or nil
							MiniFiles.open(file_path or MiniFiles.get_latest_path(), true)
							MiniFiles.reveal_cwd()
						end
					end,
				},
			},
		}

		local augroup = autocmd.group 'mini.files'

		augroup:on_user('MiniFilesBufferCreate', function(event)
			keymap {
				[{ 'n', buffer = event.data.buf_id, desc = 'Files: %s', remap = true, nowait = true }] = {
					['<Esc>'] = { 'q', 'close' },
					['<CR>'] = { 'l', 'open' },

					['w'] = { '=', 'synchronize' },
					['<Leader>'] = { 'q<Cmd>silent! WhichKey<CR><Leader>' },

					['cd'] = { ':cd ', 'cd' },

					['gc'] = {
						desc = 'go to cwd',
						function()
							MiniFiles.open(vim.fn.getcwd(), false)
						end,
					},

					['.'] = {
						desc = 'set cwd',
						function()
							local path = (MiniFiles.get_fs_entry() or {}).path
							if path then
								local cwd = vim.fs.dirname(path)
								vim.fn.chdir(cwd)
								MiniFiles.open(cwd, false)
							end
						end,
					},

					['gx'] = {
						desc = 'system open',
						function()
							vim.ui.open(MiniFiles.get_fs_entry().path)
						end,
					},
				},
			}
		end)
	end,
}
