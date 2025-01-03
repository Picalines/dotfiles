return {
	'hrsh7th/nvim-cmp',

	event = { 'InsertEnter' },

	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'saadparwaiz1/cmp_luasnip',

		'onsails/lspkind.nvim',
		'hrsh7th/cmp-nvim-lsp-signature-help',

		'L3MON4D3/LuaSnip',
	},

	config = function()
		local autocmd = require 'util.autocmd'
		local cmp = require 'cmp'
		local lspkind = require 'lspkind'
		local luasnip = require 'luasnip'

		local function has_words_before()
			local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
		end

		local function select_next(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end

		local function select_prev(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end

		local function complete_or(f)
			return function()
				if not cmp.visible() then
					cmp.complete()
				else
					f()
				end
			end
		end

		cmp.setup {
			sources = {
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'lazydev', group_index = 0 },
				{ name = 'buffer' },
			},

			mapping = {
				['<C-n>'] = complete_or(select_next),
				['<C-S-n>'] = complete_or(select_prev),

				['<C-y>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				},

				['<C-k>'] = function()
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					end
				end,

				['<C-j>'] = function()
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					end
				end,
			},

			---@diagnostic disable-next-line: missing-fields
			formatting = {
				format = lspkind.cmp_format {
					mode = 'symbol',
					maxwdith = 50,
					elipsis_char = '...',
				},
			},

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			experimental = {
				ghost_text = true,
			},
		}

		local augroup = autocmd.group 'cmp'

		augroup:on_user('Dismiss', function()
			cmp.close()
		end)
	end,
}
