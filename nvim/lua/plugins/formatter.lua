return {
	'mhartington/formatter.nvim',

	config = function()
		local function lsp_formatter()
			vim.lsp.buf.format({ async = true })
		end

		-- Manual list of formatters for filetypes
		local manual_filetype_formatters = {
			lua = { lsp_formatter },
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
			manual_filetype_formatters[filetype] = module.prettierd or module.prettier
		end

		require('formatter').setup({
			filetype = vim.tbl_extend('error', manual_filetype_formatters, {
				['*'] = {
					require("formatter.filetypes.any").remove_trailing_whitespace,

					function()
						local filetype = vim.bo.filetype
						if manual_filetype_formatters[filetype] ~= nil then
							return
						end

						local plugin_formatter_ok, plugin_formatter = pcall(require, 'formatter.filetype.' .. filetype)
						if plugin_formatter_ok then
							-- fallback to formatter.nvim's formatter
							plugin_formatter()
						else
							-- fallback to LSP's formatter
							lsp_formatter()
						end
					end
				},
			}),
		})
	end
}
