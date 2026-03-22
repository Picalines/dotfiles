local app = require 'util.app'
local func = require 'util.func'
local keymap = require 'mappet'
local signal = require 'util.signal'

local map, sub = keymap.map, keymap.sub
local keys = keymap.group 'settings.neovide'

vim.g.neovide_theme = 'auto'

vim.g.neovide_refresh_rate = 90

vim.g.neovide_padding_top = 20
vim.g.neovide_padding_bottom = 20
vim.g.neovide_padding_right = 20
vim.g.neovide_padding_left = 20

vim.g.neovide_show_border = true

vim.g.neovide_hide_mouse_when_typing = true

vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_blur_amount_x = 10
vim.g.neovide_floating_blur_amount_y = 10
vim.g.neovide_floating_corner_radius = 0.15

vim.g.neovide_cursor_animation_length = 0.015
vim.g.neovide_scroll_animation_length = 0.05
vim.g.neovide_position_animation_length = 0.05

vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

vim.g.neovide_cursor_animate_in_insert_mode = false

vim.g.neovide_window_blurred = true

local neovide_scale_factor = signal.new(1)
signal.persist(neovide_scale_factor, 'neovide.scale_factor')
signal.watch(function()
	vim.g.neovide_scale_factor = neovide_scale_factor()
end)

local neovide_opacity = signal.new(1)
signal.persist(neovide_opacity, 'neovide.opacity')
signal.watch(function()
	vim.g.neovide_opacity = neovide_opacity()
end)

local function zoom(delta)
	neovide_scale_factor(neovide_scale_factor() + delta)
end

local function toggle_opacity()
	neovide_opacity(neovide_opacity() == 1 and 0.95 or 1)
end

keys 'Neovide: %s' {
	sub { 'n', 'i', 'x', 'c' } {
		map('<D-=>', 'zoom in') { func.partial(zoom, 0.1) },
		map('<D-->', 'zoom out') { func.partial(zoom, -0.1) },
	},

	map('<Leader>ug', 'toggle opacity') { toggle_opacity },

	sub { when = app.os() == 'macos' } {
		map('<D-w>', 'write all and quit') '<Cmd>wa | qa!<CR>',
		map('<D-n>', 'new window') {
			'<Cmd>silent !open --new -b com.neovide.neovide<CR>',
		},
	},
}
