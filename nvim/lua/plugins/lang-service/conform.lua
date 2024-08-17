return {
	'stevearc/conform.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	config = function()
		local keymap = require 'util.keymap'
		local tbl = require 'util.table'
		local conform = require 'conform'
		local conform_util = require 'conform.util'

		keymap.declare {
			[{ 'n', silent = true }] = {
				['<leader>F'] = { ':Format<CR>', 'Format buffer' },
			},

			[{ 'v', silent = true }] = {
				['<leader>F'] = { ':Format<CR>', 'Format selection' },
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

			notify_on_error = true,

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
					cwd = conform_util.root_file { 'biome.json' },
					require_cwd = true,
				},
			},
		}

		vim.api.nvim_create_user_command('Format', function(args)
			local range = nil

			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					['start'] = { args.line1, 0 },
					['end'] = { args.line2, end_line:len() },
				}
			end

			conform.format {
				async = true,
				lsp_fallback = true,
				range = range,
			}
		end, { range = true })

		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
