local util = require 'util'
local persist = require 'persist'

local function open_colorscheme_picker()
	local actions = require 'telescope.actions'
	local actions_state = require 'telescope.actions.state'
	local pickers = require 'telescope.pickers'
	local finders = require 'telescope.finders'
	local sorters = require 'telescope.sorters'
	local dropdown = require('telescope.themes').get_dropdown()

	local function select_colorscheme(prompt_bufnr)
		local colorscheme = actions_state.get_selected_entry()[1]
		vim.cmd('colorscheme ' .. colorscheme)
		persist.save_item('colorscheme', colorscheme)
		actions.close(prompt_bufnr)
	end

	local function next_colorscheme(prompt_bufnr)
		actions.move_selection_next(prompt_bufnr)
		local selected = actions_state.get_selected_entry()
		local cmd = 'colorscheme ' .. selected[1]
		vim.cmd(cmd)
	end

	local function prev_colorscheme(prompt_bufnr)
		actions.move_selection_previous(prompt_bufnr)
		local selected = actions_state.get_selected_entry()
		local cmd = 'colorscheme ' .. selected[1]
		vim.cmd(cmd)
	end

	local colorschemes = vim.fn.getcompletion('', 'color')

	local opts = {
		finder = finders.new_table(colorschemes),
		sorter = sorters.get_generic_fuzzy_sorter {},

		attach_mappings = function(_, map)
			map('i', '<CR>', select_colorscheme)
			map('i', '<C-j>', next_colorscheme)
			map('i', '<C-k>', prev_colorscheme)
			return true
		end,
	}

	pickers.new(dropdown, opts):find()
end

vim.api.nvim_create_user_command('PickColorScheme', open_colorscheme_picker, {})

vim.o.background = persist.get_item('background', 'dark')

local function toggle_background()
	vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
	persist.save_item('background', vim.o.background)
end

util.declare_keymaps {
	[{ 'n', silent = true }] = {
		['<leader><leader>t'] = { ':PickColorScheme<CR>', 'Select color [t]heme' },
		['<leader><leader>b'] = { toggle_background, 'Toggle [b]ackground' },
	},
}
