local function vscode_call(action)
	return ':lua require("vscode-neovim").call("' .. action .. '")<CR>'
end

require('util').declare_keymaps {
	opts = {
		silent = true,
	},

	[{ 'n', 'v' }] = {
		['<Space>'] = '<Nop>',

		['<C-u>'] = '<C-u>zz',
		['<C-d>'] = '<C-d>zz',

		['n'] = 'nzzzv',
		['N'] = 'Nzzzv',

		['gh'] = '^',
		['gH'] = '0',
		['gl'] = '$',
	},

	i = {
		['<C-j>'] = '<Down>',
		['<C-k>'] = '<Up>',
		['<C-l>'] = '<Right>',
		['<C-h>'] = '<Left>',
	},

	v = {
		['p'] = '"_dP',

		['<S-j>'] = ":m '>+1<CR>gv=gv",
		['<S-k>'] = ":m '<-2<CR>gv=gv",
	},

	n = {
		['<C-j>'] = vscode_call 'workbench.action.navigateDown',
		['<C-k>'] = vscode_call 'workbench.action.navigateUp',
		['<C-h>'] = vscode_call 'workbench.action.navigateLeft',
		['<C-l>'] = vscode_call 'workbench.action.navigateRight',

		['<A-j>'] = vscode_call 'editor.action.moveLinesDownAction',
		['<A-k>'] = vscode_call 'editor.action.moveLinesUpAction',

		['gD'] = vscode_call 'editor.action.revealDefinition',
		['gR'] = vscode_call 'editor.action.goToReferences',
		['gI'] = vscode_call 'editor.action.goToImplementation',
		['<leader>A'] = vscode_call 'editor.action.quickFix',
		['<leader>F'] = vscode_call 'editor.action.formatDocument',
		['<leader>R'] = vscode_call 'editor.action.rename',

		[']d'] = vscode_call 'editor.action.marker.next',
		['[d'] = vscode_call 'editor.action.marker.prev',

		['<leader>ff'] = vscode_call 'workbench.action.quickOpen',
		['<leader>fg'] = vscode_call 'workbench.action.findInFiles',
		['<leader>f/'] = vscode_call 'actions.find',

		['<leader>s'] = vscode_call 'workbench.action.files.save',

		['<leader>t'] = vscode_call 'workbench.action.files.newUntitledFile',
		[']t'] = vscode_call 'workbench.action.nextEditor',
		['[t'] = vscode_call 'workbench.action.previousEditor',
		['<leader>dt'] = vscode_call 'workbench.action.closeActiveEditor',

		['<leader>e'] = vscode_call 'workbench.files.action.showActiveFileInExplorer',
		['<leader>E'] = vscode_call 'workbench.action.toggleSidebarVisibility',
		['<C-t>'] = vscode_call 'workbench.action.terminal.toggleTerminal',
	},
}
