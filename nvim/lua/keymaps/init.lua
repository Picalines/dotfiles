local app = require 'util.app'

require 'keymaps.text-editing.command'
require 'keymaps.text-editing.insert'
require 'keymaps.text-editing.motion'
require 'keymaps.text-editing.visual'
require 'keymaps.text-editing.void'

if app.client() == 'vscode' then
	require 'keymaps.ui.vscode'
else
	require 'keymaps.ui.buffer'
	require 'keymaps.ui.colorscheme'
	require 'keymaps.ui.quickfix'
	require 'keymaps.ui.tab'
	require 'keymaps.ui.window'

	if app.client() == 'neovide' then
		require 'keymaps.ui.neovide'
	end
end
