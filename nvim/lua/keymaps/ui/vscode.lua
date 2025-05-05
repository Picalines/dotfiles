local keymap = require 'util.keymap'

local function vscode_call(action)
	return string.format('<Cmd>lua require("vscode-neovim").call("%s")<CR>', action)
end

keymap {
	[{ 'n' }] = {
		['<C-j>'] = vscode_call 'workbench.action.navigateDown',
		['<C-k>'] = vscode_call 'workbench.action.navigateUp',
		['<C-h>'] = vscode_call 'workbench.action.navigateLeft',
		['<C-l>'] = vscode_call 'workbench.action.navigateRight',

		['<A-j>'] = vscode_call 'editor.action.moveLinesDownAction',
		['<A-k>'] = vscode_call 'editor.action.moveLinesUpAction',

		['gD'] = vscode_call 'editor.action.revealDefinition',
		['gR'] = vscode_call 'editor.action.goToReferences',
		['gI'] = vscode_call 'editor.action.goToImplementation',
		['<leader>a'] = vscode_call 'editor.action.quickFix',
		['<leader>F'] = vscode_call 'editor.action.formatDocument',
		['<leader>r'] = vscode_call 'editor.action.rename',

		[']d'] = vscode_call 'editor.action.marker.next',
		['[d'] = vscode_call 'editor.action.marker.prev',

		['<leader>ff'] = vscode_call 'workbench.action.quickOpen',
		['<leader>fg'] = vscode_call 'workbench.action.findInFiles',
		['<leader>f/'] = vscode_call 'actions.find',

		['<leader>w'] = vscode_call 'workbench.action.files.save',

		['<C-t>e'] = vscode_call 'workbench.action.files.newUntitledFile',
		['<C-t>c'] = vscode_call 'workbench.action.closeActiveEditor',
		[']t'] = vscode_call 'workbench.action.nextEditor',
		['[t'] = vscode_call 'workbench.action.previousEditor',

		['<leader>e'] = vscode_call 'workbench.files.action.showActiveFileInExplorer',
		['<leader>E'] = vscode_call 'workbench.action.toggleSidebarVisibility',
		['<leader>t'] = vscode_call 'workbench.action.terminal.toggleTerminal',
	},
}
