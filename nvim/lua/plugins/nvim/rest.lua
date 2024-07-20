return {
	'rest-nvim/rest.nvim',

	enabled = false,

	event = 'BufAdd',

	dependencies = { 'nvim-lua/plenary.nvim' },

	opts = {

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
				json = 'jq',
				xml = 'tidy',
				html = 'tidy',
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
	},

	config = function(_, opts)
		local keymap = require 'util.keymap'
		local rest = require 'rest-nvim'

		rest.setup(opts)

		vim.api.nvim_create_autocmd({ 'BufAdd' }, {
			pattern = { '*.http', '*.https' },
			callback = function(event)
				keymap.declare {
					[{ 'n', buffer = event.buf }] = {
						['<leader>r'] = { rest.run, '[R]un [R]est' },
					},
				}
			end,
		})
	end,
}
