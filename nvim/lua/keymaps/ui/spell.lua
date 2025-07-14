local autocmd = require 'util.autocmd'
local func = require 'util.func'
local keymap = require 'util.keymap'
local options = require 'util.options'
local signal = require 'util.signal'

local spell = signal.new(false)
signal.persist(spell, 'vim.spell')

local function toggle_spell()
	local enabled = spell(not spell())
	vim.notify('spell ' .. (enabled and 'on' or 'off'))
end

keymap {
	[{ 'n', desc = 'UI: %s' }] = {
		['<leader>us'] = { toggle_spell, 'toggle spell' },
	},
}

---@param winid integer
local function update_spell_win(winid)
	local wo, bo = options.winlocal(winid)
	wo.spell = bo.buftype == '' and spell()
end

---@param tabpage integer
local function update_spell_tabpage(tabpage)
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
		update_spell_win(winid)
	end
end

signal.watch(func.partial(update_spell_tabpage, 0))

local augroup = autocmd.group 'spell'

augroup:on({ 'TabEnter' }, '*', func.partial(update_spell_tabpage, 0))
augroup:on({ 'BufWinEnter', 'TermOpen' }, '*', func.partial(update_spell_win, 0))
