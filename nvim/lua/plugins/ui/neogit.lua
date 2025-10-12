return {
	'NeogitOrg/neogit',

	cmd = 'Neogit',

	dependencies = {
		'nvim-lua/plenary.nvim',
	},

	init = function()
		local keymap = require 'util.keymap'

		keymap {
			[{ 'n', desc = 'Git: %s' }] = {
				['<leader>g'] = { '<Cmd>Neogit<CR>', 'status' },
			},
		}
	end,

	---@module 'neogit'
	---@type NeogitConfig
	opts = {
		disable_hint = true,

		commit_editor = {
			kind = 'tab',
			staged_diff_split_kind = 'auto',
		},

		mappings = {
			status = {
				['='] = 'Toggle',
			},
			commit_editor = {
				['<cr>'] = 'Submit',
			},
			rebase_editor = {
				['<cr>'] = 'Submit',
				['K'] = 'MoveUp',
				['J'] = 'MoveDown',
			},
		},
	},
}
