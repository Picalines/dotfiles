local func = require 'util.func'
local keymap = require 'util.keymap'
local signal = require 'util.signal'

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

keymap {
	[{ 'n', desc = 'Neovide: %s' }] = {
		[{ 'n', 'i', 'x', 'c' }] = {
			['<D-=>'] = { func.partial(zoom, 0.1), 'zoom in' },
			['<D-->'] = { func.partial(zoom, -0.1), 'zoom out' },
		},

		['<Leader>ug'] = { toggle_opacity, 'toggle opacity' },

		[{ os = 'macos' }] = {
			['<D-w>'] = { '<Cmd>wa | qa!<CR>', 'write all and quit' },
			['<D-n>'] = { '<Cmd>silent !open --new -b com.neovide.neovide<CR>', 'new window' },
		},
	},
}
