local app = require 'util.app'

local guicursor = {
	'n-v-c:block',
	'i-ci-ve:ver25',
	'r-cr:hor20',
	'o:hor25',
}

if app.client() ~= 'terminal' then
	table.insert(guicursor, 'a:blinkwait500-blinkoff500-blinkon500-Cursor/lCursor')
end

vim.go.guicursor = table.concat(guicursor, ',')
