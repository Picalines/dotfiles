return {
	'olimorris/codecompanion.nvim',

	version = '*',

	dependencies = {
		'j-hui/fidget.nvim',
		'echasnovski/mini.diff',
	},

	cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat' },

	init = function()
		local autocmd = require 'util.autocmd'
		local keymap = require 'util.keymap'

		keymap {
			[{ desc = 'AI: %s' }] = {
				[{ 'n' }] = {
					['<leader>c'] = { '<Cmd>CodeCompanionChat Toggle<CR>', 'open chat' },
					['<leader>C'] = { '<Cmd>CodeCompanionActions<CR>', 'actions' },
				},
				[{ 'x' }] = {
					['<leader>c'] = { '<Cmd>CodeCompanionActions<CR>', 'actions' },
				},
			},
		}

		local augroup = autocmd.group 'codecompanion'

		augroup:on('FileType', 'codecompanion', function(event)
			keymap {
				[{ 'n', remap = true, buffer = event.buf, desc = 'AI: %s' }] = {
					['q'] = { '<C-w>c', 'close' },
					['<leader>c'] = { '<C-w>c', 'close' },
				},
			}
		end)

		-- fidget.nvim integration
		-- original: https://github.com/olimorris/codecompanion.nvim/discussions/813#discussioncomment-12289384
		local progress_handles = {}

		augroup:on_user('CodeCompanionRequestStarted', function(event)
			local fidget_progress = require 'fidget.progress'
			progress_handles[event.data.id] = fidget_progress.handle.create {
				title = ' AI',
				message = 'Generating',
				lsp_client = {
					name = event.data.adapter.formatted_name,
				},
			}
		end)

		augroup:on_user('CodeCompanionRequestFinished', function(event)
			local handle = progress_handles[event.data.id]
			progress_handles[event.data.id] = nil
			if handle then
				if event.data.status == 'success' then
					handle.message = '󰄴 Done'
				elseif event.data.status == 'error' then
					handle.message = '󰅝 Error'
				else
					handle.message = '󰜺 Cancelled'
				end

				handle:finish()
			end
		end)

		vim.cmd [[
			silent spellgood! 
			silent spellgood! 
			silent spellgood! buf
		]]
	end,

	opts = function()
		local ok, local_adapters = pcall(require, 'local.codecompanion')
		if not ok then
			local_adapters = {}
		end

		local default_adapter = local_adapters.default

		local opts = {
			adapters = local_adapters.adapters,

			display = {
				chat = {
					auto_scroll = true,
					intro_message = ' Press ? for help',
					window = {
						position = 'right',
						width = 0.35,
						opts = {
							winbar = '%=󰚩 codecompanion%=',
							number = false,
							relativenumber = false,
							signcolumn = 'no',
							wrap = true,
							breakindent = false,
							linebreak = true,
							winfixbuf = true,
							spell = true,
						},
					},
				},
				diff = {
					enabled = true,
					provider = 'mini_diff',
				},
			},

			strategies = {
				chat = {
					adapter = default_adapter,

					roles = {
						user = (os.getenv 'USER') .. ' ',
						llm = function(adapter)
							return adapter.formatted_name .. ' '
						end,
					},

					keymaps = {
						auto_tool_mode = { modes = { n = '<LocalLeader>t' } },
						change_adapter = { modes = { n = '<LocalLeader>m' } },
						clear = { modes = { n = '<LocalLeader>x' } },
						close = { modes = { n = '<Nul>' } },
						codeblock = { modes = { n = '<Nul>' } },
						debug = { modes = { n = '<LocalLeader>d' } },
						fold_code = { modes = { n = '<LocalLeader>f' } },
						pin = { modes = { n = '<LocalLeader>p' } },
						regenerate = { modes = { n = '<LocalLeader>r' } },
						stop = { modes = { n = '<LocalLeader>s' } },
						system_prompt = { modes = { n = '<LocalLeader>ps' } },
						watch = { modes = { n = '<LocalLeader>w' } },
						yank_code = { modes = { n = '<LocalLeader>y' } },
					},
				},
				inline = {
					adapter = default_adapter,

					keymaps = {
						accept_change = { modes = { n = '<LocalLeader>a' } },
						reject_change = { modes = { n = '<LocalLeader>r' } },
					},
				},
				cmd = {
					adapter = default_adapter,
				},

				tools = {
					['files'] = {
						opts = { requires_approval = true },
					},
					['cmd_runner'] = {
						opts = { requires_approval = true },
					},
				},
			},
		}

		return opts
	end,
}
