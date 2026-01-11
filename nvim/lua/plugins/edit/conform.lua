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
				['<LocalLeader>F'] = {
					desc = 'buffer',
					function()
						require('conform').format { async = vim.fn.reg_executing() == '' }
					end,
				},

				['<Leader>of'] = {
					desc = 'toggle on write',
					function()
						vim.g.format_on_write = not vim.g.format_on_write
					end,
				},

				['<LocalLeader>of'] = {
					desc = 'toggle on write',
					function()
						vim.b.format_on_write = not vim.b.format_on_write
					end,
				},
			},
		}

		local augroup = autocmd.group 'conform'

		augroup:on('BufNew', '*', function(event)
			vim.b[event.buf].format_on_write = true
		end)

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
		local conform = require 'conform'
		local conform_util = require 'conform.util'

		local function web_formatter(bufnr)
			if conform.get_formatter_info('biome-check', bufnr) then
				return { 'biome-check' }
			end
			return { 'prettierd', 'prettier', stop_after_first = true }
		end

		local function python_formatter(bufnr)
			if conform.get_formatter_info('ruff_format', bufnr).available then
				return { 'ruff_organize_imports', 'ruff_format' }
			end
			return { 'isort', 'black' }
		end

		local function from_python_venv(cmd)
			return conform_util.find_executable({ '.venv/bin/' .. cmd, 'venv/bin/' .. cmd }, cmd)
		end

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
				css = web_formatter,
				go = { 'gofmt' },
				graphql = web_formatter,
				html = web_formatter,
				javascript = web_formatter,
				javascriptreact = web_formatter,
				json = web_formatter,
				kotlin = { 'ktlint' },
				lua = { 'stylua' },
				python = python_formatter,
				svelte = web_formatter,
				typescript = web_formatter,
				typescriptreact = web_formatter,
				vue = web_formatter,
			},

			formatters = {
				black = { command = from_python_venv 'black' },
				ruff_format = { command = from_python_venv 'ruff' },
				ruff_organize_imports = { command = from_python_venv 'ruff' },
				isort = {
					command = from_python_venv 'isort',
					args = { '--profile', 'black', '--quiet', '-' },
				},
			},
		}
	end,
}
