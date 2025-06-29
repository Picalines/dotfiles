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

return {
	'olimorris/codecompanion.nvim',

	dependencies = {
		'j-hui/fidget.nvim',
		'echasnovski/mini.diff',
		{
			'MeanderingProgrammer/render-markdown.nvim',
			-- I don't like editing markdown files with the plugin,
			-- so enable it only in codecompanion window
			opts = {
				file_types = { 'codecompanion' },
				heading = { position = 'inline' },
				icons = { '󰎤 ', '󰎧 ', '󰎪 ', '󰎭 ', '󰎱 ', '󰎳 ' },
			},
		},
	},

	cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat' },

	opts = function()
		local ok, private_adapters = pcall(require, 'settings.ui.codecompanion.private-providers')
		if not ok then
			private_adapters = {}
		end

		local default_adapter = private_adapters.default

		local opts = {
			adapters = private_adapters.adapters,

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

		-- fidget.nvim integration
		-- original: https://github.com/olimorris/codecompanion.nvim/discussions/813#discussioncomment-12289384
		local progress_handles = {}

		augroup:on_user('CodeCompanionRequestStarted', function(event)
			local fidget_progress = require 'fidget.progress'
			progress_handles[event.data.id] = fidget_progress.handle.create {
				title = ' ai generation',
				message = 'in progress...',
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
					handle.message = 'done'
				elseif event.data.status == 'error' then
					handle.message = '󰅝 error'
				else
					handle.message = '󰜺 cancelled'
				end

				handle:finish()
			end
		end)

		return opts
	end,
}
