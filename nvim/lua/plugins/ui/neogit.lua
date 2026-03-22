return {
	'NeogitOrg/neogit',

	cmd = 'Neogit',

	dependencies = {
		'nvim-lua/plenary.nvim',
	},

	init = function()
		local keymap = require 'mappet'
		local map = keymap.map

		local keys = keymap.group 'plugins.ui.neogit'

		keys('Git: %s', { 'n' }) {
			map('<Leader>g', 'status') '<Cmd>Neogit<CR>',
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
