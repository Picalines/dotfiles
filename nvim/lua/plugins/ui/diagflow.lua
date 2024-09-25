return {
	'dgagn/diagflow.nvim',

	event = 'LspAttach',

	opts = {
		enable = true,

		gap_size = 1,

		scope = 'cursor',

		toggle_event = { 'InsertEnter', 'InsertLeave' },

		padding_top = 0,

		padding_right = 0,

		text_align = 'left',

		placement = 'inline',

		severity_colors = {
			error = 'DiagnosticError',
			warning = 'DiagnosticWarn',
			info = 'DiagnosticInfo',
			hint = 'DiagnosticHint',
		},
	},
}
