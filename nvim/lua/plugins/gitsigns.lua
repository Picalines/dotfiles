return {
	'lewis6991/gitsigns.nvim',

	opts = {
		signs = {
			add = { text = '│' },
			change = { text = '│' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '│' },
			untracked = { text = '┆' },
		},

		signcolumn = true,

		attach_to_untracked = true,
		watch_gitdir = {
			follow_files = true,
		},

		current_line_blame = true,
		current_line_blame_formatter = '<author> - <summary>, <author_time:%R>',
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = 'eol',
			delay = 500,
			ignore_whitespace = true,
		},

		preview_config = {
			border = 'rounded',
			relative = 'cursor',
		},

		on_attach = function(bufnr)
			local gitsigns = package.loaded.gitsigns

			local function map_key(mode, key, func, desc)
				return vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
			end

			local function goto_next_hunk()
				if vim.wo.diff then
					return ']C'
				end
				vim.schedule(gitsigns.next_hunk)
				return '<Ignore>'
			end

			local function goto_prev_hunk()
				if vim.wo.diff then
					return '[C'
				end
				vim.schedule(gitsigns.prev_hunk)
				return '<Ignore>'
			end

			map_key({ 'n', 'v' }, ']C', goto_next_hunk, 'Jump to next [C]hange')
			map_key({ 'n', 'v' }, '[C', goto_prev_hunk, 'Jump to previous [C]hange')

			map_key('n', '<leader>C', gitsigns.preview_hunk, 'Preview git [C]hange')
		end,
	},
}
