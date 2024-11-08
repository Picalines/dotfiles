local app = require 'util.app'

require 'keymaps.text-editing.command'
require 'keymaps.text-editing.insert'
require 'keymaps.text-editing.motion'

if app.client() == 'vscode' then
	require 'keymaps.ui.vscode'
else
	require 'keymaps.ui.buffer'
	require 'keymaps.ui.colorscheme'
	require 'keymaps.ui.lsp'
	require 'keymaps.ui.number'
	require 'keymaps.ui.quickfix'
	require 'keymaps.ui.quit'
	require 'keymaps.ui.tab'
	require 'keymaps.ui.window'

	if app.client() == 'neovide' then
		require 'keymaps.ui.neovide'
	end
end
