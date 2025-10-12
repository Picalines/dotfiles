return {
	'folke/snacks.nvim',

	init = function()
		local keymap = require 'util.keymap'

		keymap {
			[{ 'n', desc = 'LSP: %s' }] = {
				['gD'] = { '<Cmd>lua Snacks.picker.lsp_definitions()<CR>', 'definitions' },
				['gR'] = { '<Cmd>lua Snacks.picker.lsp_references()<CR>', 'references' },
				['gI'] = { '<Cmd>lua Snacks.picker.lsp_implementations()<CR>', 'implementations' },
				['gT'] = { '<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>', 'type definitions' },
			},

			[{ 'n', desc = 'Buffer: %s' }] = {
				['<leader>bb'] = { '<Cmd>lua Snacks.picker.buffers()<CR>', 'find' },
				['<leader>bd'] = { '<Cmd>lua Snacks.bufdelete()<CR>', 'delete' },
				['<leader>bD'] = { '<Cmd>lua Snacks.bufdelete.all()<CR>', 'delete all' },
				['<leader>bo'] = { '<Cmd>lua Snacks.bufdelete.other()<CR>', 'delete other' },
			},

			[{ 'n', desc = 'Find: %s' }] = {
				['<leader>ff'] = { '<Cmd>lua Snacks.picker.files()<CR>', 'files' },
				['<leader>fo'] = { '<Cmd>lua Snacks.picker.recent()<CR>', 'recent' },
				['<leader>fb'] = { '<Cmd>lua Snacks.picker.buffers()<CR>', 'buffer' },
				['<leader>fg'] = { '<Cmd>lua Snacks.picker.grep()<CR>', 'grep' },
				['<leader>fh'] = { '<Cmd>lua Snacks.picker.help()<CR>', 'help' },
				['<leader>fr'] = { '<Cmd>lua Snacks.picker.resume()<CR>', 'resume' },
				['<leader>ft'] = { ':set filetype=', 'filetype' },
			},

			[{ 'n', desc = 'UI: %s' }] = {
				['<leader><leader>c'] = { '<Cmd>lua Snacks.picker.colorschemes()<CR>', 'colorscheme' },
			},
		}
	end,

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
						['<C-n>'] = { 'list_down', mode = { 'n', 'i' } },
						['<C-S-n>'] = { 'list_up', mode = { 'n', 'i' } },
					},
				},
			},
			sources = {
				files = { hidden = true },
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
