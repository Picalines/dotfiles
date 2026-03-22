local keymap = require 'mappet'
local map = keymap.map

local keys = keymap.group 'settings.vscode'

local function vscode_call(action)
	return string.format('<Cmd>lua require("vscode-neovim").call("%s")<CR>', action)
end

keys { 'n' } {
	map '<C-j>' { vscode_call 'workbench.action.navigateDown' },
	map '<C-k>' { vscode_call 'workbench.action.navigateUp' },
	map '<C-h>' { vscode_call 'workbench.action.navigateLeft' },
	map '<C-l>' { vscode_call 'workbench.action.navigateRight' },

	map '<A-j>' { vscode_call 'editor.action.moveLinesDownAction' },
	map '<A-k>' { vscode_call 'editor.action.moveLinesUpAction' },

	map 'gD' { vscode_call 'editor.action.revealDefinition' },
	map 'gR' { vscode_call 'editor.action.goToReferences' },
	map 'gI' { vscode_call 'editor.action.goToImplementation' },
	map '<Leader>a' { vscode_call 'editor.action.quickFix' },
	map '<Leader>F' { vscode_call 'editor.action.formatDocument' },
	map '<Leader>r' { vscode_call 'editor.action.rename' },

	map ']d' { vscode_call 'editor.action.marker.next' },
	map '[d' { vscode_call 'editor.action.marker.prev' },

	map '<Leader>ff' { vscode_call 'workbench.action.quickOpen' },
	map '<Leader>fg' { vscode_call 'workbench.action.findInFiles' },
	map '<Leader>f/' { vscode_call 'actions.find' },

	map '<Leader>w' { vscode_call 'workbench.action.files.save' },

	map '<C-t>e' { vscode_call 'workbench.action.files.newUntitledFile' },
	map '<C-t>c' { vscode_call 'workbench.action.closeActiveEditor' },
	map ']t' { vscode_call 'workbench.action.nextEditor' },
	map '[t' { vscode_call 'workbench.action.previousEditor' },

	map '<Leader>e' { vscode_call 'workbench.files.action.showActiveFileInExplorer' },
	map '<Leader>E' { vscode_call 'workbench.action.toggleSidebarVisibility' },
	map '<Leader>t' { vscode_call 'workbench.action.terminal.toggleTerminal' },
}
