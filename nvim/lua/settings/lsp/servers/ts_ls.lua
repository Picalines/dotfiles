local func = require 'util.func'

local language_opts = {
	inlayHints = {
		includeInlayParameterNameHints = 'all',
		includeInlayParameterNameHintsWhenArgumentMatchesName = false,
		includeInlayFunctionParameterTypeHints = false,
		includeInlayVariableTypeHints = false,
		includeInlayPropertyDeclarationTypeHints = false,
		includeInlayFunctionLikeReturnTypeHints = false,
		includeInlayEnumMemberValueHints = true,
	},
}

return {
	settings = {
		completions = {
			completeFunctionCalls = true,
		},

		typescript = language_opts,
		javascript = language_opts,
	},

	handlers = {
		['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
			if result.diagnostics == nil then
				return
			end

			local formatTsErrors = require 'format-ts-errors'

			-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
			local ignored_codes = { [80001] = true }

			for _, entry in pairs(result.diagnostics) do
				if not ignored_codes[entry.code] then
					local formatter = formatTsErrors[entry.code] or func.const(entry.message)
					local ok, new_message = pcall(formatter, entry.message)
					if ok then
						entry.message = new_message
					else
						print('format-ts-errors: ', new_message)
					end
				end
			end

			vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
		end,
	},
}
