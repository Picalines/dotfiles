return {
	'stevearc/conform.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	config = function()
		local autocmd = require 'util.autocmd'
		local conform = require 'conform'
		local conform_util = require 'conform.util'
		local keymap = require 'util.keymap'
		local signal = require 'util.signal'
		local tbl = require 'util.table'

		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		local format_before_write = signal.new(false)
		signal.persist(format_before_write, 'format_before_write')

		local function toggle_autoformat()
			local is_enabled = format_before_write(not format_before_write())
			print('Auto format: ' .. (is_enabled and 'on' or 'off'))
		end

		keymap.declare {
			[{ 'n', silent = true }] = {
				['<leader>F'] = { '<Cmd>Format<CR>', 'Format buffer' },
				['<leader><leader>F'] = { toggle_autoformat, 'Toggle auto format' },
			},
		}

		-- local function is_formatter_available(formatter, bufnr)
		-- 	return conform.get_formatter_info(formatter, bufnr).available
		-- end

		local function only_first(formatters)
			return tbl.override(formatters, { stop_after_first = true })
		end

		local biome_or_prettier = only_first { 'biome', 'prettierd', 'prettier' }

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

				javascript = biome_or_prettier,
				javascriptreact = biome_or_prettier,
				typescript = biome_or_prettier,
				typescriptreact = biome_or_prettier,
				json = biome_or_prettier,
				html = biome_or_prettier,
				css = biome_or_prettier,
				svelte = biome_or_prettier,
				vue = biome_or_prettier,
				graphql = biome_or_prettier,

				go = { 'gofmt' },
				cs = { 'csharpier' },
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
					cwd = conform_util.root_file { 'biome.json', 'biome.jsonc' },
					require_cwd = true,
				},
			},
		}

		vim.api.nvim_create_user_command('Format', function()
			conform.format { async = vim.fn.reg_executing() == '' }
		end, {})

		autocmd.on('BufWritePre', '*', function(event)
			if format_before_write() then
				conform.format {
					async = false,
					bufnr = event.buf,
				}
			end
		end)
	end,
}
