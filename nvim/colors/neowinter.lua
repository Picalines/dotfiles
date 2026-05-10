local mini_hues = require 'mini.hues'

local palette

if vim.o.background == 'dark' then
	palette = mini_hues.make_palette {
		background = '#0f191f',
		foreground = '#b4bdc3',
		accent = 'azure',
		saturation = 'lowmedium',
	}
else
	palette = mini_hues.make_palette {
		background = '#ebf7fc',
		foreground = '#26332f',
		accent = 'azure',
		saturation = 'high',
	}
end

mini_hues.apply_palette(palette)
vim.g.colors_name = 'neowinter'
