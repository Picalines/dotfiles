local app = require 'util.app'
local array = require 'util.array'
local func = require 'util.func'
local keymap = require 'util.keymap'
local signal = require 'util.signal'

local guifont = signal.new(vim.o.guifont)
signal.persist(guifont, app.client() .. '.vim.guifont')
signal.watch(function()
	vim.o.guifont = guifont()
end)

local function list_guifonts_fontconfig()
	local ok, fc_list = pcall(function()
		local result = vim.system({ 'fc-list' }):wait()
		return result.code == 0 and result.stdout or nil
	end)

	if ok and fc_list then
		local font_lines = vim.split(fc_list, '\n')
		return array.unique(array.map(font_lines, function(font_line)
			return string.match(font_line, '^[^:]+:%s*([^,:]+)')
		end))
	end
end

local function list_guifonts()
	if vim.fn.executable 'fc-list' == 1 then
		return list_guifonts_fontconfig()
	end

	return nil
end

list_guifonts = func.memo(list_guifonts)

local function open_guifont_picker()
	local guifonts = list_guifonts()

	if not guifonts then
		print "couldn't list installed fonts"
		return
	end

	local actions = require 'telescope.actions'
	local actions_state = require 'telescope.actions.state'
	local pickers = require 'telescope.pickers'
	local finders = require 'telescope.finders'
	local sorters = require 'telescope.sorters'
	local dropdown = require('telescope.themes').get_dropdown()

	local function update_font()
		local current_entry = actions_state.get_selected_entry()
		return guifont(current_entry[1])
	end

	local opts = {
		prompt_title = 'Select guifont',

		finder = finders.new_table(guifonts),
		sorter = sorters.get_generic_fuzzy_sorter {},

		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				update_font()
			end)

			return true
		end,
	}

	pickers.new(dropdown, opts):find()
end

vim.api.nvim_create_user_command('PickGuiFont', open_guifont_picker, {})

keymap.declare {
	[{ 'n' }] = {
		['<leader><leader>f'] = { '<Cmd>PickGuiFont<CR>', 'Select guifont' },
	},
}
