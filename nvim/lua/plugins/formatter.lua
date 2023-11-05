return {
	'mhartington/formatter.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	config = function()
		local util = require 'formatter.util'

		local function map_formatter(formatter, config_mapper)
			local config = formatter()
			if config == nil then
				return nil
			end

			return config_mapper(config)
		end

		local function format_mapper(config_mapper)
			return function(formatter)
				return map_formatter(formatter, config_mapper)
			end
		end

		local with_current_file_cwd = format_mapper(function(config)
			return vim.tbl_extend('force', config, {
				cwd = util.get_current_buffer_file_dir(),
			})
		end)

		local lsp_formatter = vim.lsp.buf.format

		-- Manual list of formatters for filetypes
		local manual_formatters = {
			lua = { require('formatter.filetypes.lua').stylua },
			python = { require('formatter.filetypes.python').black },

			javascript = { require('formatter.filetypes.javascript').prettierd },
			javascriptreact = { require('formatter.filetypes.javascriptreact').prettierd },
			typescript = { require('formatter.filetypes.typescript').prettierd },
			typescriptreact = { require('formatter.filetypes.typescriptreact').prettierd },
			json = { require('formatter.filetypes.json').prettierd },
			html = { require('formatter.filetypes.html').prettierd },
			css = { require('formatter.filetypes.css').prettierd },
			svelte = { require('formatter.filetypes.svelte').prettier },
			vue = { require('formatter.filetypes.vue').prettier },

			go = { require('formatter.filetypes.go').gofmt },
			c = { with_current_file_cwd(require('formatter.filetypes.c').clangformat) },
			h = { with_current_file_cwd(require('formatter.filetypes.c').clangformat) },
			cpp = { with_current_file_cwd(require('formatter.filetypes.cpp').clangformat) },
			cs = {
				function() return { exe = 'dotnet', stdin = true, args = { 'csharpier', '--fast', '--skip-write', '--write-stdout', '--' } } end,
			},

			java = { require('formatter.filetypes.java').clangformat },
		}

		local function builtin_or_lsp_formatter()
			local filetype = vim.bo.filetype
			if manual_formatters[filetype] == nil then
				return
			end

			local has_builtin_formatter, builtin_module = pcall(require, 'formatter.filetypes.' .. filetype)
			if has_builtin_formatter then
				local _, builtin_formatter = next(builtin_module)
				builtin_formatter() -- fallback to formatter.nvim's formatter
			else
				lsp_formatter() -- fallback to LSP's formatter
			end
		end

		local formatters = vim.tbl_extend('error', manual_formatters, {
			['*'] = {
				require('formatter.filetypes.any').remove_trailing_whitespace,

				builtin_or_lsp_formatter,

				function()
					-- save file if it was saved before formatting
					if not vim.bo.modified then
						vim.cmd.w()
					end
				end,
			},
		})

		require('formatter').setup {
			filetype = formatters,
		}
	end,
}
