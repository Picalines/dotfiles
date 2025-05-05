return {
	'stevearc/conform.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	config = function()
		local autocmd = require 'util.autocmd'
		local conform = require 'conform'
		local keymap = require 'util.keymap'
		local signal = require 'util.signal'

		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		local format_before_write = signal.new(false)
		signal.persist(format_before_write, 'plugin.conform.format_before_write')
		signal.watch(function()
			vim.g.status_format_before_write = format_before_write()
		end)

		local function toggle_autoformat()
			local is_enabled = format_before_write(not format_before_write())
			print('Auto format: ' .. (is_enabled and 'on' or 'off'))
		end

		keymap {
			[{ 'n', silent = true, desc = 'Format: %s' }] = {
				['<leader>F'] = { '<Cmd>Format<CR>', 'buffer' },
				['<leader>uf'] = { toggle_autoformat, 'toggle auto' },
			},
		}

		-- local function is_formatter_available(formatter, bufnr)
		-- 	return conform.get_formatter_info(formatter, bufnr).available
		-- end

		local web_formatters = {
			'biome',
			'prettierd',
			'prettier',
			stop_after_first = true,
		}

		conform.setup {
			notify_on_error = true,
			notify_no_formatters = true,

			default_format_opts = {
				lsp_format = 'fallback',
				timeout_ms = 3000,
				stop_after_first = false,
			},

			formatters_by_ft = {
				lua = { 'stylua' },
				python = { 'isort', 'black' },

				javascript = web_formatters,
				javascriptreact = web_formatters,
				typescript = web_formatters,
				typescriptreact = web_formatters,
				json = web_formatters,
				html = web_formatters,
				css = web_formatters,
				svelte = web_formatters,
				vue = web_formatters,
				graphql = web_formatters,

				go = { 'gofmt' },
				cs = { 'csharpier' },

				kotlin = { 'ktlint' },
			},

			formatters = {
				isort = {
					command = 'isort',
					args = {
						'--profile',
						'black',
						'--quiet',
						'-',
					},
				},

				biome = {
					require_cwd = true,
					stdin = true,
					args = {
						'check',
						'--write',
						'--formatter-enabled=true',
						'--organize-imports-enabled=true',
						'--graphql-formatter-enabled=true',
						'--css-formatter-enabled=true',
						'--linter-enabled=true',
						'--stdin-file-path',
						'$FILENAME',
					},
				},
			},
		}

		vim.api.nvim_create_user_command('Format', function()
			conform.format { async = vim.fn.reg_executing() == '' }
		end, {})

		local augroup = autocmd.group 'conform'

		augroup:on('BufWritePre', '*', function(event)
			if format_before_write() then
				conform.format {
					async = false,
					bufnr = event.buf,
				}
			end
		end)
	end,
}
