local app = require 'util.app'

require 'keymaps.text-editing'

if app.client() == 'vscode' then
	require 'keymaps.ui.vscode'
else
	require 'keymaps.ui.buffer'
	require 'keymaps.ui.lsp'
	require 'keymaps.ui.quickfix'
	require 'keymaps.ui.tab'
	require 'keymaps.ui.window'

	if app.client() == 'neovide' then
		require 'keymaps.ui.neovide'
	end
end
