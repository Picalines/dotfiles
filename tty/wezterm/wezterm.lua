local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local main_font = wezterm.font 'IosevkaTerm Nerd Font Mono'

config.max_fps = 120
config.front_end = 'WebGpu'

config.font = main_font
config.font_size = 20

local function get_color_scheme(appearance)
	return appearance:find 'Light' and 'neobones_light' or 'neobones_dark'
end

wezterm.on('window-config-reloaded', function(window)
	local window_config = window:get_config_overrides() or {}

	window_config.color_scheme = get_color_scheme(window:get_appearance())

	window:set_config_overrides(window_config)
end)

config.window_decorations = 'RESIZE'
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

config.enable_tab_bar = false
config.window_frame = {
	font = main_font,
	font_size = 16,
}

return config
