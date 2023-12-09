return {
	'rest-nvim/rest.nvim',

	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		local rest = require 'rest-nvim'

		local auto_format = vim.cmd.Format

		rest.setup {
			result_split_horizontal = false,
			result_split_in_place = true,

			-- Skip SSL verification, useful for unknown certificates
			skip_ssl_verification = false,

			encode_url = true,

			result = {
				show_url = true,

				show_curl_command = true,
				show_http_info = true,
				show_headers = true,

				formatters = {
					json = auto_format,
					xml = auto_format,
					html = auto_format,
				},
			},

			jump_to_request = false,
			env_file = '.env',
			custom_dynamic_variables = {},
			yank_dry_run = true,

			highlight = {
				enabled = true,
				timeout = 150,
			},
		}

		vim.api.nvim_create_autocmd({ 'BufAdd' }, {
			pattern = { '*.http', '*.https' },
			callback = function(event)
				require('util').declare_keymaps {
					opts = {
						buffer = event.buf,
					},
					n = {
						['<leader>r'] = { rest.run, '[R]un [R]est' },
					},
				}
			end,
		})
	end,
}
