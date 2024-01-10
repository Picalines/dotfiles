return {
	'stevearc/conform.nvim',

	event = { 'BufReadPre', 'BufNewFile' },

	opts = {
		formatters_by_ft = {
			lua = { 'stylua' },
			python = { 'isort', 'black' },

			javascript = { { 'prettierd', 'prettier' } },
			javascriptreact = { { 'prettierd', 'prettier' } },
			typescript = { { 'prettierd', 'prettier' } },
			typescriptreact = { { 'prettierd', 'prettier' } },
			json = { { 'prettierd', 'prettier' } },
			html = { { 'prettierd', 'prettier' } },
			css = { { 'prettierd', 'prettier' } },
			svelte = { { 'prettierd', 'prettier' } },
			vue = { { 'prettierd', 'prettier' } },

			go = { 'gofmt' },
			cs = { 'csharpier' },
		},
	},

	config = function(_, opts)
		local conform = require 'conform'
		local util = require 'util'

		conform.setup(opts)

		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		local function buf_format(range)
			conform.format { async = true, lsp_fallback = true, range = range }
		end

		vim.api.nvim_create_user_command('Format', function(args)
			local range = nil

			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					['start'] = { args.line1, 0 },
					['end'] = { args.line2, end_line:len() },
				}
			end

			buf_format(range)
		end, { range = true })

		util.declare_keymaps {
			opts = {
				silent = true,
			},

			[{ 'n', 'v' }] = {
				['<leader>F'] = { ':Format<CR>', 'Format current buffer' },
			},
		}
	end,
}
