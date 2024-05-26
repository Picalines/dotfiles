return {
	'hrsh7th/nvim-cmp',

	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',

		'onsails/lspkind.nvim',
		'hrsh7th/cmp-nvim-lsp-signature-help',

		'L3MON4D3/LuaSnip',
	},

	event = { 'InsertEnter', 'CmdlineEnter' },

	config = function()
		local util = require 'util'
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		local lspkind = require 'lspkind'

		local function has_words_before()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
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

		cmp.setup {
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'buffer' },
				{ name = 'nvim_lsp_signature_help' },
			},

			mapping = cmp.mapping.preset.insert {
				['<C-Space>'] = cmp.mapping.complete(),

				['<Tab>'] = cmp.mapping(select_next, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(select_prev, { 'i', 's' }),

				['<C-k>'] = cmp.mapping.scroll_docs(-4),
				['<C-j>'] = cmp.mapping.scroll_docs(4),

				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
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
		}

		util.declare_keymaps {
			opts = {
				silent = true,
			},
			i = {
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
		}
	end,
}
