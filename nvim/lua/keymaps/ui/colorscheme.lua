local keymap = require 'util.keymap'

local function open_colorscheme_picker()
	local actions = require 'telescope.actions'
	local actions_set = require 'telescope.actions.set'
	local actions_state = require 'telescope.actions.state'
	local pickers = require 'telescope.pickers'
	local finders = require 'telescope.finders'
	local sorters = require 'telescope.sorters'
	local dropdown = require('telescope.themes').get_dropdown()

	local colorschemes = vim.fn.getcompletion('', 'color')
	local current_colorscheme = vim.g.colors_name or colorschemes[1]

	local function update_colorscheme()
		local current_entry = actions_state.get_selected_entry()
		local colorscheme = current_entry[1]
		vim.cmd.colorscheme(colorscheme)
		return colorscheme
	end

	local function reset_colorscheme()
		vim.cmd.colorscheme(current_colorscheme)
	end

	local opts = {
		prompt_title = 'Select colorscheme',

		finder = finders.new_table(colorschemes),
		sorter = sorters.get_generic_fuzzy_sorter {},

		attach_mappings = function(prompt_bufnr)
			---@diagnostic disable-next-line: undefined-field
			actions.close:enhance { post = reset_colorscheme }

			---@diagnostic disable-next-line: undefined-field
			actions_set.shift_selection:enhance { post = update_colorscheme }

			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				update_colorscheme()
			end)

			return true
		end,
	}

	pickers.new(dropdown, opts):find()
end

vim.api.nvim_create_user_command('PickColorScheme', open_colorscheme_picker, {})

keymap {
	[{ 'n', silent = true, desc = 'UI: %s' }] = {
		['<leader>uC'] = { '<Cmd>PickColorScheme<CR>', 'colorscheme' },
	},
}
