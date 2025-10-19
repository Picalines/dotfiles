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
		['<Leader>a'] = vscode_call 'editor.action.quickFix',
		['<Leader>F'] = vscode_call 'editor.action.formatDocument',
		['<Leader>r'] = vscode_call 'editor.action.rename',

		[']d'] = vscode_call 'editor.action.marker.next',
		['[d'] = vscode_call 'editor.action.marker.prev',

		['<Leader>ff'] = vscode_call 'workbench.action.quickOpen',
		['<Leader>fg'] = vscode_call 'workbench.action.findInFiles',
		['<Leader>f/'] = vscode_call 'actions.find',

		['<Leader>w'] = vscode_call 'workbench.action.files.save',

		['<C-t>e'] = vscode_call 'workbench.action.files.newUntitledFile',
		['<C-t>c'] = vscode_call 'workbench.action.closeActiveEditor',
		[']t'] = vscode_call 'workbench.action.nextEditor',
		['[t'] = vscode_call 'workbench.action.previousEditor',

		['<Leader>e'] = vscode_call 'workbench.files.action.showActiveFileInExplorer',
		['<Leader>E'] = vscode_call 'workbench.action.toggleSidebarVisibility',
		['<Leader>t'] = vscode_call 'workbench.action.terminal.toggleTerminal',
	},
}
