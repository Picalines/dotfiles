return {
	'folke/snacks.nvim',

	init = function()
		local keymap = require 'mappet'
		local map = keymap.map

		local keys = keymap.group 'plugins.ui.snacks'

		keys 'LSP: %s' {
			map('gD', 'definitions') '<Cmd>lua Snacks.picker.lsp_definitions()<CR>',
			map('gR', 'references') '<Cmd>lua Snacks.picker.lsp_references()<CR>',
			map('gI', 'implementations') '<Cmd>lua Snacks.picker.lsp_implementations()<CR>',
			map('gT', 'type definitions') '<Cmd>lua Snacks.picker.lsp_type_definitions()<CR>',
		}

		keys 'Buffer: %s' {
			map('<Leader>b', 'find') '<Cmd>lua Snacks.picker.buffers()<CR>',
			map('<LocalLeader>bd', 'delete') '<Cmd>lua Snacks.bufdelete()<CR>',
			map('<LocalLeader>bD', 'delete all') '<Cmd>lua Snacks.bufdelete.all()<CR>',
			map('<LocalLeader>bo', 'delete other') '<Cmd>lua Snacks.bufdelete.other()<CR>',
		}

		keys 'Find: %s' {
			map('<Leader>ff', 'files') '<Cmd>lua Snacks.picker.files()<CR>',
			map('<Leader>fo', 'recent') '<Cmd>lua Snacks.picker.recent()<CR>',
			map('<Leader>fg', 'grep') '<Cmd>lua Snacks.picker.grep()<CR>',
			map('<Leader>fh', 'help') '<Cmd>lua Snacks.picker.help()<CR>',
			map('<Leader>fs', 'symbols') '<Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>',
			map('<Leader>fr', 'resume') '<Cmd>lua Snacks.picker.resume()<CR>',
			map('<LocalLeader>fs', 'symbols') '<Cmd>lua Snacks.picker.lsp_symbols()<CR>',
			map('<LocalLeader>ft', 'filetype') ':set filetype=',
		}

		keys 'UI: %s' {
			map('<Leader>oC', 'colorscheme') '<Cmd>lua Snacks.picker.colorschemes()<CR>',
		}
	end,

	---@module 'snacks'
	---@return snacks.Config
	opts = function()
		local ts_workspace_symbol_kinds = {
			'Class',
			'Variable', -- exported constants are also variables :/
			'Constant',
			'Enum',
			'Function',
			'Interface',
			'Module',
			'Namespace',
		}

		return {
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
							['<C-f>'] = { 'fullscreen', mode = { 'i' } },
							['<C-d>'] = { 'preview_scroll_down', mode = { 'n', 'i' } },
							['<C-u>'] = { 'preview_scroll_up', mode = { 'n', 'i' } },
						},
					},
				},
				actions = {
					fullscreen = function(picker)
						picker:set_layout 'fullscreen'
					end,
				},
				layouts = {
					fullscreen = {
						layout = {
							box = 'vertical',
							backdrop = false,
							width = 0.9,
							height = 0.9,
							border = true,
							title = '{title}',
							title_pos = 'center',
							{ win = 'preview', height = 0.75 },
							{ win = 'input', height = 1, border = 'top' },
							{ win = 'list', border = 'top' },
						},
					},
				},
				sources = {
					files = { hidden = true },
					lsp_workspace_symbols = {
						filter = {
							typescript = ts_workspace_symbol_kinds,
							typescriptreact = ts_workspace_symbol_kinds,
							javascript = ts_workspace_symbol_kinds,
							javascriptreact = ts_workspace_symbol_kinds,
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

			image = {
				enabled = true,
				formats = { 'png' },
			},
		}
	end,
}
