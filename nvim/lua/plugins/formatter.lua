return {
	'mhartington/formatter.nvim',

	config = function()
		local function lsp_formatter()
			vim.lsp.buf.format()
		end

		-- Manual list of formatters for filetypes
		local manual_filetype_formatters = {
			lua = { require('formatter.filetypes.lua').stylua },
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

		require('formatter').setup {
			filetype = vim.tbl_extend('error', manual_filetype_formatters, {
				['*'] = {
					require('formatter.filetypes.any').remove_trailing_whitespace,

					function()
						local filetype = vim.bo.filetype
						if manual_filetype_formatters[filetype] ~= nil then
							return
						end

						local plugin_formatter_ok, builtin_module = pcall(require, 'formatter.filetypes.' .. filetype)
						if plugin_formatter_ok then
							local _, builtin_formatter = next(builtin_module)

							-- fallback to formatter.nvim's formatter
							builtin_formatter()
						else
							-- fallback to LSP's formatter
							lsp_formatter()
						end
					end,
				},
			}),
		}
	end,
}
