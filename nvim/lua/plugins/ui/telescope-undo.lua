return {
	'debugloop/telescope-undo.nvim',

	dependencies = {
		{
			'nvim-telescope/telescope.nvim',
			dependencies = { 'nvim-lua/plenary.nvim' },
		},
	},

	keys = {
		{
			'<leader>U',
			'<cmd>Telescope undo<cr>',
			desc = '[u]ndo history',
		},
	},

	config = function()
		local telescope = require 'telescope'
		local undo = require 'telescope-undo.actions'

		telescope.setup {
			extensions = {
				undo = {
					entry_format = '#$ID $STAT $TIME',

					side_by_side = true,
					layout_strategy = 'vertical',
					layout_config = {
						preview_height = 0.8,
					},

					mappings = {
						i = {
							['<S-CR>'] = false,
							['<C-CR>'] = false,

							['<CR>'] = undo.restore,
							['<C-r>'] = undo.restore,
							['<C-y>'] = undo.yank_additions,
							['<S-y>'] = undo.yank_deletions,
						},
						n = {
							['<CR>'] = undo.restore,
							['y'] = undo.yank_additions,
							['<S-y>'] = undo.yank_deletions,
						},
					},
				},
			},
		}

		telescope.load_extension 'undo'
	end,
}
