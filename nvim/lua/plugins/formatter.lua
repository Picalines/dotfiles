return {
	'mhartington/formatter.nvim',

	config = function()
		local function lsp_formatter()
			vim.lsp.buf.format()
		end

		-- Manual list of formatters for filetypes
		local manual_filetype_formatters = {
			lua = { require('formatter.filetypes.lua').stylua },
			python = { require('formatter.filetypes.python').black },
		}

		local prettier_filetypes = {
			'javascript',
			'javascriptreact',
			'typescript',
			'typescriptreact',
			'json',
			'css',
		}

		for _, filetype in ipairs(prettier_filetypes) do
			local module = require('formatter.filetypes.' .. filetype)
			manual_filetype_formatters[filetype] = module.prettierd
		end

		local function builtin_or_lsp_formatter()
			local filetype = vim.bo.filetype
			if manual_filetype_formatters[filetype] == nil then
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

		local formatters = vim.tbl_extend('error', manual_filetype_formatters, {
			['*'] = {
				require('formatter.filetypes.any').remove_trailing_whitespace,

				builtin_or_lsp_formatter,

				function()
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
