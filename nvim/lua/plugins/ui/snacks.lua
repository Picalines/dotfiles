return {
	'folke/snacks.nvim',

	config = function(_, opts)
		local snacks = require 'snacks'
		snacks.setup(opts)

		local keymap = require 'mappet'
		local map = keymap.map

		local keys = keymap.group 'plugins.ui.snacks'

		keys 'LSP: %s' {
			map('gD', 'definitions') { snacks.picker.lsp_definitions },
			map('gR', 'references') { snacks.picker.lsp_references },
			map('gI', 'implementations') { snacks.picker.lsp_implementations },
			map('gT', 'type definitions') { snacks.picker.lsp_type_definitions },
			map('<Leader>l', 'attached servers') {
				function()
					snacks.picker.lsp_config { attached = 0 }
				end,
			},
		}

		keys 'Buffer: %s' {
			map('<Leader>b', 'find') { snacks.picker.buffers },
			map('<LocalLeader>bd', 'delete') { snacks.bufdelete.delete },
			map('<LocalLeader>bD', 'delete all') { snacks.bufdelete.all },
			map('<LocalLeader>bo', 'delete other') { snacks.bufdelete.other },
		}

		keys 'Find: %s' {
			map('<Leader>ff', 'files') { snacks.picker.files },
			map('<Leader>fo', 'recent') { snacks.picker.recent },
			map('<Leader>fg', 'grep') { snacks.picker.grep },
			map('<Leader>fh', 'help') { snacks.picker.help },
			map('<Leader>fs', 'symbols') { snacks.picker.lsp_workspace_symbols },
			map('<Leader>fr', 'resume') { snacks.picker.resume },
			map('<LocalLeader>fs', 'symbols') { snacks.picker.lsp_symbols },
			map('<LocalLeader>ft', 'filetype') ':set filetype=',
		}

		keys 'UI: %s' {
			map('<Leader>oC', 'colorscheme') { snacks.picker.colorschemes },
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
					grep = { hidden = true },
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
