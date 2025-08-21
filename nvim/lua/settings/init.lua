local app = require 'util.app'

require 'settings.global'
require 'settings.tab'
require 'settings.window'
require 'settings.buffer'
require 'settings.quickfix'

if app.client() == 'vscode' then
	require 'settings.vscode'
else
	require 'settings.colorscheme'
	require 'settings.lsp'
	require 'settings.spell'
end

if app.client() == 'neovide' then
	require 'settings.neovide'
end
