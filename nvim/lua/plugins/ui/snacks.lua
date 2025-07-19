local keymap = require 'util.keymap'

keymap {
	[{ 'n', desc = 'Buffer: %s' }] = {
		['<leader>bd'] = { '<Cmd>lua Snacks.bufdelete()<CR>', 'delete' },
		['<leader>bD'] = { '<Cmd>lua Snacks.bufdelete.all()<CR>', 'delete all' },
		['<leader>bo'] = { '<Cmd>lua Snacks.bufdelete.other()<CR>', 'delete other' },
	},

	[{ 'n', desc = 'Find: %s' }] = {
		['gD'] = { '<Cmd>lua Snacks.picker.lsp_definitions()<CR>', 'lsp definitions' },
		['gR'] = { '<Cmd>lua Snacks.picker.lsp_references()<CR>', 'lsp references' },
		['gI'] = { '<Cmd>lua Snacks.picker.lsp_implementations()<CR>', 'lsp implementations' },
		['gT'] = { '<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>', 'lsp type definitions' },

		['<leader>bb'] = { '<Cmd>lua Snacks.picker.buffers()<CR>', 'buffer' },

		['<leader>ff'] = { '<Cmd>lua Snacks.picker.files()<CR>', 'files' },
		['<leader>fo'] = { '<Cmd>lua Snacks.picker.recent()<CR>', 'recent' },
		['<leader>fb'] = { '<Cmd>lua Snacks.picker.buffers()<CR>', 'buffer' },
		['<leader>fg'] = { '<Cmd>lua Snacks.picker.grep()<CR>', 'grep' },
		['<leader>fh'] = { '<Cmd>lua Snacks.picker.help()<CR>', 'help' },
		['<leader>fr'] = { '<Cmd>lua Snacks.picker.resume()<CR>', 'resume' },
		['<leader>ft'] = { ':set filetype=', 'filetype' },

		['<leader>uC'] = { '<Cmd>lua Snacks.picker.colorschemes()<CR>', 'colorscheme' },
	},
}

return {
	'folke/snacks.nvim',

	---@module 'snacks'
	---@type snacks.Config
	opts = {
		indent = {
			enabled = true,
			hl = 'Whitespace',
			filter = function(buf)
				local bo = vim.bo[buf]
				return bo.buftype == '' and bo.filetype ~= 'markdown'
			end,
		},

		picker = {
			ui_select = true,
			layout = {
				preset = 'select',
				layout = { row = 2 },
			},
			win = {
				input = {
					keys = {
						['<Esc>'] = { 'close', mode = { 'n', 'i' } },
						['<c-b>'] = false,
						['<c-p>'] = false,
					},
				},
			},
		},

		input = {
			enabled = true,
			icon_pos = 'title',
			icon = '󰙏',
			win = {
				relative = 'cursor',
				title_pos = 'left',
				row = 1,
			},
		},
	},
}
