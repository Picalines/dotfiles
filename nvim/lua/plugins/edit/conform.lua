return {
	'stevearc/conform.nvim',

	lazy = true,

	init = function()
		local autocmd = require 'util.autocmd'
		local keymap = require 'mappet'
		local map = keymap.map

		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		vim.g.format_on_write = true

		local keys = keymap.group 'plugins.edit.conform'

		keys('Format: %s', { 'n' }) {
			map('<LocalLeader>F', 'buffer') {
				function()
					require('conform').format { async = vim.fn.reg_executing() == '' }
				end,
			},

			map('<Leader>of', 'toggle on write') {
				function()
					vim.g.format_on_write = not vim.g.format_on_write
				end,
			},

			map('<LocalLeader>of', 'toggle on write') {
				function()
					vim.b.format_on_write = not vim.b.format_on_write
				end,
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

		local function is_available(formatter, bufnr)
			return conform.get_formatter_info(formatter, bufnr).available
		end

		-- Note:
		-- 1. Legacy formatters should come last
		-- 2. All formatters are resolved from the PATH (use mise.local to override stuff)
		-- 3. Add lua functions for special cases (for example, run black and isort in pair)

		local web_formatter = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true }

		local function python_formatter(bufnr)
			if is_available('ruff_format', bufnr) then
				return { 'ruff_organize_imports', 'ruff_format' }
			end

			return { 'isort', 'black' }
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
				isort = {
					args = { '--profile', 'black', '--quiet', '-' },
				},
			},
		}
	end,
}
