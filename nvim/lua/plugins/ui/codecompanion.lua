local autocmd = require 'util.autocmd'
local keymap = require 'util.keymap'

keymap {
	[{ 'n', desc = 'AI: %s' }] = {
		['<leader>C'] = { '<Cmd>CodeCompanion<CR>', 'inline prompt' },
		['<leader>cc'] = { '<Cmd>CodeCompanionChat Toggle<CR>', 'open chat' },
	},
}

local augroup = autocmd.group 'codecompanion'

augroup:on('FileType', 'codecompanion', function(event)
	keymap {
		[{ 'n', remap = true, buffer = event.buf, desc = 'AI: %s' }] = {
			['q'] = { '<C-w>c', 'close' },
			['<leader>cc'] = { '<C-w>c', 'close' },
		},
	}
end)

return {
	'olimorris/codecompanion.nvim',

	dependencies = {
		'j-hui/fidget.nvim',
		{
			'MeanderingProgrammer/render-markdown.nvim',
			-- I don't like editing markdown files with the plugin,
			-- so enable it only in codecompanion window
			ft = { 'codecompanion' },
			opts = { file_types = { 'codecompanion' } },
		},
	},

	cmd = { 'CodeCompanion', 'CodeCompanionChat' },

	opts = function()
		local ok, private_adapters = pcall(require, 'settings.ui.codecompanion.private-providers')
		if not ok then
			private_adapters = {}
		end

		local default_adapter = private_adapters.default

		return {
			adapters = private_adapters.adapters,

			display = {
				chat = {
					auto_scroll = true,
					intro_message = ' Press ? for help',
					window = {
						position = 'right',
						width = 0.35,
					},
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
						stop = { modes = { n = 's' } },
					},
				},
				inline = {
					adapter = default_adapter,
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
	end,

	init = function()
		-- fidget.nvim integration
		-- original: https://github.com/olimorris/codecompanion.nvim/discussions/813#discussioncomment-12289384
		local fidget_progress = require 'fidget.progress'

		local progress_handles = {}

		augroup:on_user('CodeCompanionRequestStarted', function(event)
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
	end,
}
