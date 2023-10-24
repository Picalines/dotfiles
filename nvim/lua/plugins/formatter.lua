return {
	'mhartington/formatter.nvim',

	config = function()
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
			css = { require('formatter.filetypes.css').prettierd },
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
