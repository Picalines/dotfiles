local app = require 'util.app'

require 'settings.ui.chars'
require 'settings.ui.search'
require 'settings.ui.window'
require 'settings.ui.wrapping'

if app.client() ~= 'vscode' then
	require 'settings.ui.spell'
	require 'settings.ui.buflisted'
	require 'settings.ui.colorscheme'
	require 'settings.ui.guicursor'
	require 'settings.ui.help'
	require 'settings.ui.lsp'
	require 'settings.ui.yank-highlight'
end

if app.client() == 'neovide' then
	require 'settings.ui.neovide'
end
