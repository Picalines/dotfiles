return {
	'lewis6991/gitsigns.nvim',

	opts = {
		signs = {
			add = { text = '+' },
			change = { text = '~' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '~' },
		},

		on_attach = function(bufnr)
			local function map_key(mode, key, func, desc)
				return vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
			end

			map_key('n', '<leader>hp', require('gitsigns').preview_hunk, 'Preview git hunk')

			-- don't override the built-in and fugitive keymaps
			local gs = package.loaded.gitsigns

			local function goto_next_hunk()
				if vim.wo.diff then
					return ']c'
				end
				vim.schedule(gs.next_hunk)
				return '<Ignore>'
			end

			local function goto_prev_hunk()
				if vim.wo.diff then
					return '[c'
				end
				vim.schedule(gs.prev_hunk)
				return '<Ignore>'
			end

			map_key({ 'n', 'v' }, ']c', goto_next_hunk, 'Jump to next hunk')
			map_key({ 'n', 'v' }, '[c', goto_prev_hunk, 'Jump to previous hunk')
		end,
	},
}
