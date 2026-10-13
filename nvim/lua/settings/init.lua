local app = require 'util.app'

require 'settings.buffer'
require 'settings.global'
require 'settings.quit'
require 'settings.tab'
require 'settings.window'

if app.client() == 'vscode' then
	require 'settings.vscode'
else
	require 'settings.colorscheme'
	require 'settings.diff'
	require 'settings.lsp'
	require 'settings.spell'
	require 'settings.treesitter'
end

if app.client() == 'neovide' then
	require 'settings.neovide'
end
