local app = require 'util.app'

require 'settings.text-editing.autoreload'
require 'settings.text-editing.clipboard'
require 'settings.text-editing.completeopt'
require 'settings.text-editing.indent'
require 'settings.text-editing.pairs'
require 'settings.text-editing.undo'

require 'settings.ui.number-column'
require 'settings.ui.search'
require 'settings.ui.window'
require 'settings.ui.wrapping'

if app.client() ~= 'vscode' then
	require 'settings.ui.colorscheme'
	require 'settings.ui.lsp'
	require 'settings.ui.yank-highlight'
end

if app.client() == 'neovide' then
	require 'settings.ui.neovide'
end

-- NOTE: lsp folder is loaded by lspconfig
