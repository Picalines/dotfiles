return {
	'stevearc/conform.nvim',

	lazy = true,

	init = function()
		local autocmd = require 'util.autocmd'
		local keymap = require 'util.keymap'

		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		vim.g.format_on_write = true

		keymap {
			[{ 'n', desc = 'Format: %s' }] = {
				['<leader>F'] = {
					desc = 'buffer',
					function()
						require('conform').format { async = vim.fn.reg_executing() == '' }
					end,
				},

				['<leader>uf'] = {
					desc = 'toggle on write',
					function()
						vim.g.format_on_write = not vim.g.format_on_write
					end,
				},
			},
		}

		local augroup = autocmd.group 'conform'

		augroup:on('BufRead', { '*lock.json', '*lock.yaml' }, function(event)
			vim.b[event.buf].format_on_write = false
		end)

		augroup:on('BufWritePre', '*', function(event)
			if vim.g.format_on_write and vim.b[event.buf].format_on_write ~= false then
				require('conform').format { async = false, bufnr = event.buf }
			end
		end)
	end,

	opts = function()
		local web_formatters = {
			'biome-check',
			'prettierd',
			'prettier',
			stop_after_first = true,
		}

		return {
			notify_on_error = true,
			notify_no_formatters = true,

			default_format_opts = {
				lsp_format = 'fallback',
				timeout_ms = 3000,
				stop_after_first = false,
			},

			formatters_by_ft = {
				cs = { 'csharpier' },
				css = web_formatters,
				go = { 'gofmt' },
				graphql = web_formatters,
				html = web_formatters,
				javascript = web_formatters,
				javascriptreact = web_formatters,
				json = web_formatters,
				kotlin = { 'ktlint' },
				lua = { 'stylua' },
				python = { 'isort', 'black' },
				svelte = web_formatters,
				typescript = web_formatters,
				typescriptreact = web_formatters,
				vue = web_formatters,
			},

			formatters = {
				isort = {
					command = 'isort',
					args = { '--profile', 'black', '--quiet', '-' },
				},
			},
		}
	end,
}
