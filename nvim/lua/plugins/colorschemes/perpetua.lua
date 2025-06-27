local autocmd = require 'util.autocmd'
local hl = require 'util.highlight'

hl.link_colorschemes_by_background(autocmd.group 'perpetua', {
	light = 'perpetua-light',
	dark = 'perpetua-dark',
})

return {
	'perpetuatheme/nvim',
	name = 'perpetua',
	lazy = false,
	priority = 1000,
}
