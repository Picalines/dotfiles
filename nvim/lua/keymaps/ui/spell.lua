local autocmd = require 'util.autocmd'
local func = require 'util.func'
local keymap = require 'util.keymap'
local signal = require 'util.signal'

local spell = signal.new(false)
signal.persist(spell, 'vim.spell')

local function toggle_spell()
	local is_on = spell(not spell())
	print('Spell check: ' .. (is_on and 'on' or 'off'))
end

keymap {
	[{ 'n', desc = 'UI: %s' }] = {
		['<leader>us'] = { toggle_spell, 'toggle spell' },
	},
}

---@param winid integer
local function update_spell_win(winid)
	local buf = vim.api.nvim_win_get_buf(winid)
	local is_normal_buf = vim.bo[buf].buftype == ''
	local spell_enabled = is_normal_buf and spell()

	vim.api.nvim_set_option_value('spell', spell_enabled, { scope = 'local', win = winid })
end

---@param tabpage integer
local function update_spell_tabpage(tabpage)
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
		update_spell_win(winid)
	end
end

signal.watch(func.curry(update_spell_tabpage, 0))

local augroup = autocmd.group 'spell'

augroup:on({ 'TabEnter' }, '*', func.curry(update_spell_tabpage, 0))
augroup:on({ 'BufWinEnter', 'TermOpen' }, '*', func.curry(update_spell_win, 0))
