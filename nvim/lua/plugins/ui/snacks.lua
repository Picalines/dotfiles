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
				['<Leader>b'] = { '<Cmd>lua Snacks.picker.buffers()<CR>', 'find' },
				['<LocalLeader>bd'] = { '<Cmd>lua Snacks.bufdelete()<CR>', 'delete' },
				['<LocalLeader>bD'] = { '<Cmd>lua Snacks.bufdelete.all()<CR>', 'delete all' },
				['<LocalLeader>bo'] = { '<Cmd>lua Snacks.bufdelete.other()<CR>', 'delete other' },
			},

			[{ 'n', desc = 'Find: %s' }] = {
				['<Leader>ff'] = { '<Cmd>lua Snacks.picker.files()<CR>', 'files' },
				['<Leader>fo'] = { '<Cmd>lua Snacks.picker.recent()<CR>', 'recent' },
				['<Leader>fg'] = { '<Cmd>lua Snacks.picker.grep()<CR>', 'grep' },
				['<Leader>fh'] = { '<Cmd>lua Snacks.picker.help()<CR>', 'help' },
				['<Leader>fr'] = { '<Cmd>lua Snacks.picker.resume()<CR>', 'resume' },
				['<Leader>ft'] = { ':set filetype=', 'filetype' },
			},

			[{ 'n', desc = 'UI: %s' }] = {
				['<Leader>c'] = { '<Cmd>lua Snacks.picker.colorschemes()<CR>', 'colorscheme' },
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
